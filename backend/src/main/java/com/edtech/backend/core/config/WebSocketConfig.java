package com.edtech.backend.core.config;

import com.edtech.backend.security.jwt.JwtService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.Ordered;
import org.springframework.core.annotation.Order;
import org.springframework.messaging.Message;
import org.springframework.messaging.MessageChannel;
import org.springframework.messaging.simp.config.ChannelRegistration;
import org.springframework.messaging.simp.config.MessageBrokerRegistry;
import org.springframework.messaging.simp.stomp.StompCommand;
import org.springframework.messaging.simp.stomp.StompHeaderAccessor;
import org.springframework.messaging.support.ChannelInterceptor;
import org.springframework.messaging.support.MessageHeaderAccessor;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.web.socket.config.annotation.EnableWebSocketMessageBroker;
import org.springframework.web.socket.config.annotation.StompEndpointRegistry;
import org.springframework.web.socket.config.annotation.WebSocketMessageBrokerConfigurer;

import java.util.List;

@Configuration
@EnableWebSocketMessageBroker
@RequiredArgsConstructor
@Slf4j
@Order(Ordered.HIGHEST_PRECEDENCE + 99)
public class WebSocketConfig implements WebSocketMessageBrokerConfigurer {

    private final JwtService jwtService;
    private final UserDetailsService userDetailsService;

    @Override
    public void configureMessageBroker(MessageBrokerRegistry config) {
        // Enable a simple memory-based message broker
        // /topic for broadcast, /queue for user-specific messages
        config.enableSimpleBroker("/topic", "/queue");
        // Prefix for messages sent from client to server (@MessageMapping)
        config.setApplicationDestinationPrefixes("/app");
        // Prefix used to identify user destinations
        config.setUserDestinationPrefix("/user");
    }

    @Override
    public void registerStompEndpoints(StompEndpointRegistry registry) {
        // The endpoint clients will use to connect to the WebSocket server
        registry.addEndpoint("/ws")
                .setAllowedOriginPatterns("*") // Allow all origins for dev
                .withSockJS(); // Fallback option
    }

    @Override
    public void configureClientInboundChannel(ChannelRegistration registration) {
        registration.interceptors(new ChannelInterceptor() {
            @Override
            public Message<?> preSend(Message<?> message, MessageChannel channel) {
                StompHeaderAccessor accessor = MessageHeaderAccessor.getAccessor(message, StompHeaderAccessor.class);
                
                if (StompCommand.CONNECT.equals(accessor.getCommand())) {
                    List<String> authorization = accessor.getNativeHeader("Authorization");
                    log.debug("WebSocket connect request. Auth head present: {}", authorization != null);
                    
                    if (authorization != null && !authorization.isEmpty()) {
                        String authHeader = authorization.get(0);
                        if (authHeader.startsWith("Bearer ")) {
                            String jwt = authHeader.substring(7);
                            try {
                                String username = jwtService.extractUsername(jwt);
                                if (username != null) {
                                    UserDetails userDetails = userDetailsService.loadUserByUsername(username);
                                    if (jwtService.isTokenValid(jwt, userDetails)) {
                                        UsernamePasswordAuthenticationToken authentication = 
                                            new UsernamePasswordAuthenticationToken(userDetails, null, userDetails.getAuthorities());
                                        SecurityContextHolder.getContext().setAuthentication(authentication);
                                        accessor.setUser(authentication);
                                        log.info("WebSocket connected successfully for user: {}", username);
                                    } else {
                                        log.warn("Invalid JWT token on WebSocket connect");
                                    }
                                }
                            } catch (Exception e) {
                                log.error("Failed to authenticate WebSocket connection", e);
                            }
                        }
                    } else {
                        log.warn("Missing Authorization header on WebSocket connect");
                    }
                }
                return message;
            }
        });
    }
}
