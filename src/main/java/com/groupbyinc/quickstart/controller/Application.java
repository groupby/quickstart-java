package com.groupbyinc.quickstart.controller;

import com.groupbyinc.common.blip.BlipClient;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.context.embedded.EmbeddedServletContainerCustomizer;
import org.springframework.boot.context.embedded.ErrorPage;
import org.springframework.boot.context.web.SpringBootServletInitializer;
import org.springframework.context.annotation.Bean;
import org.springframework.http.HttpStatus;

@SpringBootApplication
public class Application extends SpringBootServletInitializer {

  @Value("${blip.server}")
  private String blipServer;
  @Value("${blip.server.environment}")
  private String blipEnvironment;
  @Value("${blip.server.service}")
  private String blipService;

  @Override
  protected SpringApplicationBuilder configure(SpringApplicationBuilder application) {
    return application.sources(Application.class);
  }

  public static void main(String[] args) throws Exception {
    SpringApplication.run(Application.class, args);
  }

  @Bean
  BlipClient blipClient() {
    return new BlipClient(blipServer, blipEnvironment, blipService);
  }

  @Bean
  public EmbeddedServletContainerCustomizer containerCustomizer() {
    return container -> container.addErrorPages(new ErrorPage(HttpStatus.NOT_FOUND, "/404.html"));
  }

}