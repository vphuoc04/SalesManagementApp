package com.example.backend.resources;

import java.time.LocalDateTime;

import org.springframework.http.HttpStatus;

import com.fasterxml.jackson.annotation.JsonInclude;

import lombok.Data;

@JsonInclude(JsonInclude.Include.NON_NULL)
@Data
public class ResponseResource<T> {
    private boolean success;
    private String message;
    private T data;
    private HttpStatus status;
    private LocalDateTime timestamp;
    private ErrorResource error;
    private T errors;

    @Data
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class ErrorResource {
        private String code;
        private String message;
        private String detail;

        public ErrorResource(String message) {
            this.message = message;
        }

        public ErrorResource(String code, String message) {
            this.code = code;
            this.message = message;
        }

        public ErrorResource(String code, String message, String detail) {
            this.code = code;
            this.message = message;
            this.detail = detail;
        }
    }

    private ResponseResource() {
        this.timestamp = LocalDateTime.now();
    }

    public static <T> Builder<T> builder() {
        return new Builder<>();
    }

    public static class Builder<T> {
        private final ResponseResource<T> resource;

        private Builder() {
            resource = new ResponseResource<>();
        }

        public Builder<T> success(Boolean success) {
            resource.success = success;
            return this;
        }

        public Builder<T> message(String message) {
            resource.message = message;
            return this;
        }

        public Builder<T> data(T data) {
            resource.data = data;
            return this;
        }

        public Builder<T> errors(T errors) {
            resource.errors = errors;
            resource.data = null;
            return this;
        }

        public Builder<T> status(HttpStatus status) {
            resource.status = status;
            return this;
        }

        public Builder<T> error(ErrorResource error) {
            resource.error = error;
            return this;
        }

        public ResponseResource<T> build() {
            return resource;
        }
    }

    public static <T> ResponseResource<T> ok(T data, String message) {
        return ResponseResource.<T>builder()
                .success(true)
                .data(data)
                .message(message)
                .status(HttpStatus.OK)
                .build();
    }

    public static <T> ResponseResource<T> message(String message, HttpStatus status){
        return  ResponseResource.<T>builder()
            .success(true)
            .message(message)
            .status(status)
            .build();
    }

    public static <T> ResponseResource<T> error(String code, String message, HttpStatus status){
        return ResponseResource.<T>builder()
            .success(false)
            .error(new ErrorResource(code, message))
            .status(status)
            .build();
    }
}
