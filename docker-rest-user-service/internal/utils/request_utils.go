/*
 * Copyright (c) 2023, WSO2 LLC. (https://www.wso2.com/) All Rights Reserved.
 *
 * WSO2 LLC. licenses this file to you under the Apache License,
 * Version 2.0 (the "License"); you may not use this file except
 * in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied. See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

package utils

import (
	"context"

	"github.com/gofiber/fiber/v2"
)

const correlationIdHeaderName = "x-correlation-id"
const correlationIdCtxKey = "correlation-id"

func GetRequestContext(rCtx *fiber.Ctx) context.Context {
	correlationId := rCtx.Get(correlationIdHeaderName)
	ctx := context.Background()
	return context.WithValue(ctx, correlationIdCtxKey, correlationId)
}

func FiberErrorHandler(c *fiber.Ctx, err error) error {
	// Default 500 status code
	code := fiber.StatusInternalServerError
	msg := "internal server error"

	if e, ok := err.(*fiber.Error); ok {
		// Override status code if fiber.Error type
		code = e.Code
		msg = e.Error()
	}
	c.Set(fiber.HeaderContentType, fiber.MIMEApplicationJSON)

	// Return status code with error message
	return c.Status(code).JSON(ErrorResponse{Message: msg})
}

type ErrorResponse struct {
	Message string `json:"message" example:"error message"`
}
