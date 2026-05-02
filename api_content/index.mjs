export const handler = async (event) => {
  console.log("Evento recibido:", JSON.stringify(event, null, 2));
  
  return {
    statusCode: 200,
    headers: {
      "Content-Type": "application/json"
    },
    body: JSON.stringify({
      mensaje: "¡Hola! Esta es mi Lambda desplegada con Terraform",
      tiempo: new Date().toISOString()
    }),
  };
};