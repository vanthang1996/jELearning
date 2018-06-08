package com.spring.config.websocket;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;

@Controller
public class MessageController {

    @Autowired
    private SimpMessagingTemplate template;
 
//    @MessageMapping("/chat")
//    public void greeting(Message<Object> message, @Payload ChatMessage chatMessage) throws Exception {
//        Principal principal = message.getHeaders().get(SimpMessageHeaderAccessor.USER_HEADER, Principal.class);
//        String authedSender = principal.getName();
//        chatMessage.setSender(authedSender);
//        System.err.println(chatMessage.getMessage().toString());
//        String recipient = chatMessage.getRecipient();
//        if (!authedSender.equals(recipient)) {
//            template.convertAndSendToUser(authedSender, "/queue/messages", chatMessage);
//        }
//        template.convertAndSendToUser(recipient, "/queue/messages", chatMessage);
//    }
}
