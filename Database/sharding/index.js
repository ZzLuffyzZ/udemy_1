const app = require("express")();
const knex = require('knex');
const { default: ShortUniqueId } = require('short-unique-id');

const clients = {
    "miyagi": knex({
        client: 'pg',
        connection: {
            "host": "0.0.0.0",
            "port": "5433",
            "user": "postgres",
            "password": "123456",
            "database": "postgres"
        },
        pool: {
            min: 2,
            max: 100,
            acquireTimeoutMillis: 300000,
            createTimeoutMillis: 300000,
            destroyTimeoutMillis: 300000,
            idleTimeoutMillis: 30000,
            reapIntervalMillis: 1000,
            createRetryIntervalMillis: 2000
        },
    }),
    "nara": knex({
        client: 'pg',
        connection: {
            "host": "0.0.0.0",
            "port": "5434",
            "user": "postgres",
            "password": "123456",
            "database": "postgres"
        },
        pool: {
            min: 2,
            max: 100,
            acquireTimeoutMillis: 300000,
            createTimeoutMillis: 300000,
            destroyTimeoutMillis: 300000,
            idleTimeoutMillis: 30000,
            reapIntervalMillis: 1000,
            createRetryIntervalMillis: 2000
        },
    }),
    "dnwa": knex({
        client: 'pg',
        connection: {
            "host": "0.0.0.0",
            "port": "5435",
            "user": "postgres",
            "password": "123456",
            "database": "postgres"
        },
        pool: {
            min: 2,
            max: 100,
            acquireTimeoutMillis: 300000,
            createTimeoutMillis: 300000,
            destroyTimeoutMillis: 300000,
            idleTimeoutMillis: 30000,
            reapIntervalMillis: 1000,
            createRetryIntervalMillis: 2000
        },
    }),
}

app.get("/:tenant/:id", async (req, res) => {
    const { tenant, id } = req.params;
    if (!clients[tenant]) {
        return res.send({});
    }
    const result = await clients[tenant]('url_table').where('url_id', id);
    return res.send({
        "urlId": tenant,
        ...result,
    })
})

app.post("/:tenant", async (req, res) => {

    const tenant = req.params.tenant;
    if (!clients[tenant]) {
        return res.send({});
    }
    const uid = new ShortUniqueId({ length: 5, dictionary: 'alpha_upper' });
    const urlId = uid.randomUUID();
    await clients[tenant]('url_table').insert({
        url: req.originalUrl,
        url_id: urlId,
    });
    res.send({
        "urlId": urlId,
    })
})

app.listen(8081, () => console.log("Listening 8081"))