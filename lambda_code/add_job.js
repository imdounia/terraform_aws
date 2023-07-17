const AWS = require("aws-sdk");
const dynamodb = new AWS.DynamoDB.DocumentClient();

exports.handler = async (event) => {
  try {
    const { id, content, job_type, isProcessed } = event;

    const params = {
      TableName: "job_table",
      Item: {
        id: id,
        content: content,
        job_type: job_type,
        isProcessed: "false",
      },
    };

    await dynamodb.put(params).promise();

    const response = {
      statusCode: 200,
      body: JSON.stringify({
        message: "Job added successfully",
      }),
    };

    return response;
  } catch (error) {
    const response = {
      statusCode: 500,
      body: JSON.stringify({
        message: `Error adding job : ${error.message}`,
      }),
    };

    return response;
  }
};