import 'package:async_message_queue_controller/async_message_queue_controller.dart';
import "dart:async";

/// The callback used by the controller to "process" a message/payload
/// Here the payload is a simple string, an simulates a heavy process
/// lasting 1 second.
/// returns a Map
Future<Map<String,String>> process(dynamic msg){
  return new Future.delayed(const Duration(seconds: 1), () => {'OK':' Processed msg : $msg'});
}


/// Initializes a simple string message controller
void main() async {

  var mqc = new AsyncMessageQueueController<String, Map<String,String>>(process);


  Stream<Map<String, String>>? s = mqc.start();

  mqc.queueMessage('Hello'); // will appear after 1 sec
  mqc.queueMessage('World'); // will appear after 2 sec

  // stop the process after 3 seconds
  new Timer(new Duration(seconds: 3), ()=> mqc.queueMessage('stop') );

  // will not be processed
  new Timer(new Duration(seconds: 4), ()=> mqc.queueMessage('will not be processed') );

  // Loop waiting for processed values
  await for (var value in s!) {
    if (value['OK'] == ' Processed msg : stop') break;
    print(value['OK']);

  }
  mqc.stop();

}
