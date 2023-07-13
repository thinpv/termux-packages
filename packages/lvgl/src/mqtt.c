/*
 * This example shows how to write a client that subscribes to a topic and does
 * not do anything other than handle the messages that are received.
 */

#include <mosquitto.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <json-c/json.h>

#define HC_TO_LCD_TOPIC "/hc/lcd"
#define LCD_TO_HC_TOPIC "/lcd/hc"

extern void change_screen(int index);

/* Callback called when the client receives a CONNACK message from the broker. */
void on_connect(struct mosquitto *mosq, void *obj, int reason_code)
{
	int rc;
	/* Print out the connection result. mosquitto_connack_string() produces an
	 * appropriate string for MQTT v3.x clients, the equivalent for MQTT v5.0
	 * clients is mosquitto_reason_string().
	 */
	printf("on_connect: %s\n", mosquitto_connack_string(reason_code));
	if(reason_code != 0){
		/* If the connection fails for any reason, we don't want to keep on
		 * retrying in this example, so disconnect. Without this, the client
		 * will attempt to reconnect. */
		mosquitto_disconnect(mosq);
	}

	/* Making subscriptions in the on_connect() callback means that if the
	 * connection drops and is automatically resumed by the client, then the
	 * subscriptions will be recreated when the client reconnects. */
	rc = mosquitto_subscribe(mosq, NULL, HC_TO_LCD_TOPIC, 1);
	if(rc != MOSQ_ERR_SUCCESS){
		fprintf(stderr, "Error subscribing: %s\n", mosquitto_strerror(rc));
		/* We might as well disconnect if we were unable to subscribe */
		mosquitto_disconnect(mosq);
	}
}


/* Callback called when the broker sends a SUBACK in response to a SUBSCRIBE. */
void on_subscribe(struct mosquitto *mosq, void *obj, int mid, int qos_count, const int *granted_qos)
{
	int i;
	bool have_subscription = false;

	/* In this example we only subscribe to a single topic at once, but a
	 * SUBSCRIBE can contain many topics at once, so this is one way to check
	 * them all. */
	for(i=0; i<qos_count; i++){
		printf("on_subscribe: %d:granted qos = %d\n", i, granted_qos[i]);
		if(granted_qos[i] <= 2){
			have_subscription = true;
		}
	}
	if(have_subscription == false){
		/* The broker rejected all of our subscriptions, we know we only sent
		 * the one SUBSCRIBE, so there is no point remaining connected. */
		fprintf(stderr, "Error: All subscriptions rejected.\n");
		mosquitto_disconnect(mosq);
	}
}

static struct json_object *jsonObj, *cmdObj, *dataObj, *indexObj;
static char *cmd;
static int index = 0;
/* Callback called when the client receives a message. */
void on_message(struct mosquitto *mosq, void *obj, const struct mosquitto_message *msg)
{
	/* This blindly prints the payload, but the payload can be anything so take care. */
	printf("%s %d %s\n", msg->topic, msg->qos, (char *)msg->payload);
	if(strcmp(HC_TO_LCD_TOPIC, msg->topic) == 0)
	{
		jsonObj = json_tokener_parse(msg->payload);
		if(jsonObj)
		{
			cmdObj = json_object_object_get(jsonObj, "cmd");
			dataObj = json_object_object_get(jsonObj, "data");
			if (cmdObj && json_object_is_type(cmdObj, json_type_string) && 
					dataObj && json_object_is_type(dataObj, json_type_object))
			{
				cmd = (char*)json_object_get_string(cmdObj);
				if(strcmp("ChangeScreen", cmd) == 0)
				{
					indexObj = json_object_object_get(dataObj, "index");
					if (indexObj && json_object_is_type(indexObj, json_type_int))
					{
						int indexTemp = json_object_get_int(indexObj);
						if(indexTemp != index)
						{
							index = indexTemp;
							change_screen(index);
						}
					}
					else 
					{
						printf("data format error\n");
					}
				}
				else 
				{
					printf("cmd not match: %s\n", cmd);
				}
			}
			else 
			{
				printf("data format error\n");
			}
			json_object_put(jsonObj);
		}
		else 
		{
			printf("json parsing error\n");
		}
	}
}

static struct mosquitto *mosq;
int mqtt_init(void)
{
	int rc;

	/* Required before calling other mosquitto functions */
	mosquitto_lib_init();

	/* Create a new client instance.
	 * id = NULL -> ask the broker to generate a client id for us
	 * clean session = true -> the broker should remove old sessions when we connect
	 * obj = NULL -> we aren't passing any of our private data for callbacks
	 */
	mosq = mosquitto_new(NULL, true, NULL);
	if(mosq == NULL){
		fprintf(stderr, "Error: Out of memory.\n");
		return 1;
	}

	/* Configure callbacks. This should be done before connecting ideally. */
	mosquitto_connect_callback_set(mosq, on_connect);
	mosquitto_subscribe_callback_set(mosq, on_subscribe);
	mosquitto_message_callback_set(mosq, on_message);

	/* Run the network loop in a blocking call. The only thing we do in this
	 * example is to print incoming messages, so a blocking call here is fine.
	 *
	 * This call will continue forever, carrying automatic reconnections if
	 * necessary, until the user calls mosquitto_disconnect().
	 */
	mosquitto_loop_start(mosq);//, -1, 1);

	/* Connect to test.mosquitto.org on port 1883, with a keepalive of 60 seconds.
	 * This call makes the socket connection only, it does not complete the MQTT
	 * CONNECT/CONNACK flow, you should use mosquitto_loop_start() or
	 * mosquitto_loop_forever() for processing net traffic. */
	rc = mosquitto_connect_async(mosq, "localhost", 1883, 60);
	if(rc != MOSQ_ERR_SUCCESS){
		mosquitto_destroy(mosq);
		fprintf(stderr, "Error: %s\n", mosquitto_strerror(rc));
		return 1;
	}

	// mosquitto_lib_cleanup();
	return 0;
}

static struct json_object *sendJsonObj = NULL;
static struct json_object *sendDataObj = NULL;
void send_change_screen_event(int index)
{
	if(sendJsonObj == NULL || sendDataObj == NULL)
	{
		sendJsonObj = json_object_new_object();
		sendDataObj = json_object_new_object();
		json_object_object_add(sendJsonObj, "cmd", json_object_new_string("ChangeScreen"));
		json_object_object_add(sendJsonObj, "data", sendDataObj);
	}
	json_object_object_add(sendDataObj, "index", json_object_new_int(index));
	const char* str = json_object_to_json_string_ext(sendJsonObj, JSON_C_TO_STRING_SPACED | JSON_C_TO_STRING_PRETTY);
	printf("publish: %s\n", str);
	mosquitto_publish(mosq, NULL, LCD_TO_HC_TOPIC, strlen(str), str, 0, false);
}