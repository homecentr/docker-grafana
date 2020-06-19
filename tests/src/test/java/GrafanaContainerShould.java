import helpers.GrafanaImageTagResolver;
import io.homecentr.testcontainers.containers.GenericContainerEx;
import io.homecentr.testcontainers.containers.HttpResponse;
import org.junit.AfterClass;
import org.junit.BeforeClass;
import org.junit.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.testcontainers.containers.GenericContainer;
import org.testcontainers.containers.output.Slf4jLogConsumer;
import org.testcontainers.containers.wait.strategy.Wait;

import java.io.IOException;
import java.time.Duration;

import static io.homecentr.testcontainers.WaitLoop.waitFor;
import static org.junit.Assert.assertEquals;

public class GrafanaContainerShould {
    private static final Logger logger = LoggerFactory.getLogger(GrafanaContainerShould.class);

    private static GenericContainerEx _container;

    @BeforeClass
    public static void setUp() {
        _container = new GenericContainerEx<>(new GrafanaImageTagResolver())
                .waitingFor(Wait.forLogMessage(".*HTTP Server Listen.*", 1));

        _container.start();
        _container.followOutput(new Slf4jLogConsumer(logger));
    }

    @AfterClass
    public static void cleanUp() {
        _container.close();
    }

    @Test
    public void listenOnMetricsEndpoint() throws IOException {
        HttpResponse response = _container.makeHttpRequest(3000, "/metrics");

        assertEquals(200, response.getResponseCode());
    }

    @Test
    public void reportAsHealthy() throws Exception {
        waitFor(Duration.ofSeconds(40), () -> _container.getCurrentContainerInfo().getState().getHealth().getStatus().equals("healthy"));
    }
}