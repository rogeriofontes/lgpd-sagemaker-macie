// index.js

const AWS = require('aws-sdk');

exports.handler = async (event) => {
    const sagemaker = new AWS.SageMakerRuntime();
    
    // Endpoint do SageMaker passado como variável de ambiente
    const endpointName = process.env.SAGEMAKER_ENDPOINT_NAME;

    console.log('SageMaker Endpoint:', endpointName);
    console.log('Input Payload:', JSON.stringify(event));

    // Dados de entrada para o modelo
    const inputPayload = JSON.stringify(event);

    try {
        // Chama o endpoint do SageMaker
        const params = {
            EndpointName: endpointName,
            Body: inputPayload,
            ContentType: 'application/json'
        };

        console.log('SageMaker Invocation Params:', JSON.stringify(params));

        const result = await sagemaker.invokeEndpoint(params).promise();
        
        // Retorna a resposta do modelo
        console.log('SageMaker Response:', result);

        // Retorna a resposta do modelo
        return {
            statusCode: 200,
            body: result.Body.toString('utf-8')
        };
    } catch (error) {
        console.error('Erro ao invocar o endpoint do SageMaker:', error);
        return {
            statusCode: 500,
            body: `Erro ao processar a solicitação: ${error.message}`
        };
    }
};
