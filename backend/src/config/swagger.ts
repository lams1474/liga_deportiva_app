import swaggerJSDoc from "swagger-jsdoc";

const swaggerDefinition = {
    openapi: "3.0.0",

    info: {
        title: "API Liga Deportiva Barrial José Ignacio Izurieta",
        version: "1.0.0",
        description:
            "API REST para la gestión de la Liga Deportiva Barrial José Ignacio Izurieta."
    },

    servers: [
        {
            url: "http://localhost:3000",
            description: "Servidor local"
        }
    ],

    components: {
        securitySchemes: {
            bearerAuth: {
                type: "http",
                scheme: "bearer",
                bearerFormat: "JWT"
            }
        }
    },

    security: [
        {
            bearerAuth: []
        }
    ]
};

const swaggerOptions = {
    definition: swaggerDefinition,

    apis: [
        `${process.cwd()}/src/routes/*.ts`
    ]
};

const swaggerSpec = swaggerJSDoc(swaggerOptions);

export default swaggerSpec;