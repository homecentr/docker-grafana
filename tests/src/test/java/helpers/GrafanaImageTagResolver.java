package helpers;

import io.homecentr.testcontainers.images.EnvironmentImageTagResolver;

public class GrafanaImageTagResolver extends EnvironmentImageTagResolver {
    public GrafanaImageTagResolver() {
        super("homecentr/grafana:local");
    }
}