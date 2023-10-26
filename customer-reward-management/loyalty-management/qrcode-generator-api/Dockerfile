# Copyright (c) 2023, WSO2 LLC. (https://www.wso2.com/) All Rights Reserved.
#
# WSO2 LLC. licenses this file to you under the Apache License,
# Version 2.0 (the "License"); you may not use this file except
# in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied. See the License for the
# specific language governing permissions and limitations
# under the License.

FROM maven:3.9.0-eclipse-temurin-19-focal as build
ENV HOME=/usr/app
RUN mkdir -p $HOME
WORKDIR $HOME
ADD . $HOME
RUN mvn -version
RUN mvn package -Dmaven.test.skip
RUN echo $JAVA_HOME
FROM eclipse-temurin:19-jre-alpine
COPY --from=build /usr/app/target/qrcode-generator-api-1.0.0.jar /app/qrcode-generator-api-1.0.0.jar

# Set a non-root user
USER 10014
EXPOSE 8080
ENTRYPOINT java -jar /app/qrcode-generator-api-1.0.0.jar
