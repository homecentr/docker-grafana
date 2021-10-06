FROM grafana/grafana:8.1.7 as original

FROM homecentr/base:2.4.3-alpine

ENV PATH="/usr/share/grafana/bin:$PATH"
ENV GF_PATHS_CONFIG="/config/grafana.ini"
ENV GF_PATHS_PROVISIONING="/config/provisioning"
ENV GF_PATHS_DATA="/grafana"
ENV GF_PATHS_PLUGINS="/grafana/plugins"
ENV GF_PATHS_LOGS="/logs"
ENV GF_PATHS_HOME="/usr/share/grafana"
ENV HEALTHCHECK_ENDPOINT="/metrics"

COPY --from=original /usr/share/grafana /usr/share/grafana
COPY --from=original /run.sh /run.sh

COPY ./fs/ /

RUN apk add --no-cache curl=7.69.1-r0

RUN  mkdir -p "$GF_PATHS_PROVISIONING/datasources" \
             "$GF_PATHS_PROVISIONING/dashboards" \
             "$GF_PATHS_PROVISIONING/notifiers" \
             "$GF_PATHS_LOGS" \
             "$GF_PATHS_PLUGINS" \
             "$GF_PATHS_DATA" && \
             cp "$GF_PATHS_HOME/conf/sample.ini" "$GF_PATHS_CONFIG" && \
             cp "$GF_PATHS_HOME/conf/ldap.toml" /config/ldap.toml && \
             chmod -R 777 "$GF_PATHS_DATA" "$GF_PATHS_HOME/.aws" "$GF_PATHS_LOGS" "$GF_PATHS_PLUGINS" "$GF_PATHS_PROVISIONING"

# Configuration
VOLUME "/config"

# Service state
VOLUME "/grafana"

# Log files
VOLUME "/logs"

# Ping the metrics endpoint
HEALTHCHECK --interval=15s --timeout=10s --start-period=20s --retries=3 CMD curl -k --fail http://127.0.0.1:3000/$HEALTHCHECK_ENDPOINT || exit 1

# HTTP User interface and API
EXPOSE 3000
