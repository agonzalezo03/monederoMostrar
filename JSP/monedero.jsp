<%-- 
    Document   : monedero
    Created on : 5 oct. 2023, 21:24:57
    Author     : Clases
--%>

<%@page import="java.math.BigDecimal"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>JSP Page</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/CSS/mostrarVuelta.css"/>
</head>
<body>
<% 
    //Almacenamos los datos de precio y pago
    String precio = request.getParameter("precio");
    String pago = request.getParameter("pago");
    BigDecimal precioNumero = new BigDecimal(precio);
    BigDecimal pagoNumero = new BigDecimal(pago);
    //Almacenamos el separador que vamos a usar
    String separador = "#";
    //Guarda los billetes y monedas separados por el separador
    StringBuilder billetes = new StringBuilder("500#200#100#50#20#10#5#2#1#0.50#0.20#0.10#0.05#0.02#0.01#");
    //Almacena la cantidad de billetes
    StringBuilder numeroBilletes = new StringBuilder("");
    //Almacena el nombre de la imagen de cada billete
    StringBuilder billetesImg = new StringBuilder("");
    int posicionActual = 0;
    //Uso BigDecimal ya que es mas preciso, si usuasemos double me devuelve un centimo menos
    BigDecimal cambio = pagoNumero.subtract(precioNumero);
    String mensaje = "";
    Boolean puedeComprar = false;
    
    //Si  pago es inferior al precio devuelve un mensaje de error
    if (precioNumero.compareTo(pagoNumero) > 0) {
        mensaje = "No tienes dinero suficiente";
        puedeComprar = true;
    } else {
    //Se repite 15 veces ya que es la cantidad e billetes que hay
        for (int indice = 0; indice < 15; indice++) {
            //Indica en que posicion se encuentra el separador
            int indiceSeparador = billetes.indexOf(separador, posicionActual);

            //devuelve el billete que usaremos indicando la posicion de inicio y la posicion donde se encuentra el separador
            String cantidadStr = billetes.substring(posicionActual, indiceSeparador);
            //Pasamos esa cantidad a una variable con la que podamos trabajar
            BigDecimal cantidad = new BigDecimal(cantidadStr);

            //Dividemos el cambio entre el valor del billete o moneda para que nos de la cantidad de billetes que se devuelven de ese tipo
            int numBilletes = cambio.divideToIntegralValue(cantidad).intValue();

            if (numBilletes > 0) {
                //Almacenamos la cantidad de billetes y le ponemos un separador
                numeroBilletes.append(numBilletes).append(separador);
                //Almacenamos el billete que se devuelbe con la xtension .png y un separador
                billetesImg.append(cantidadStr).append(".png").append(separador);
                //Multiplicamos el numero de billetes que usamos por el billete y se lo restamos al cambio
                cambio = cambio.subtract(cantidad.multiply(new BigDecimal(numBilletes)));
            }
            //Movemos la posicion actual al siguiente separador
            posicionActual = indiceSeparador + separador.length();
        }
        //Para usar la posicionActual mas adelante le ponemos el valor 0 de nuevo
        posicionActual = 0;
    }
    //Volvemos a poner el cambio
    cambio = pagoNumero.subtract(precioNumero);
%>

<h1>Devolver</h1>
<div class="container">
<% 
int posicionActual2 = 0;
//Muestra los billetes y la cantidad de canda uno
//hacemos que se repita 15 veces ya que es la cantidad de billetes totales que hay
for (int i = 0; i < 15; i++) {
    int indiceSeparadorCantidad = numeroBilletes.indexOf(separador, posicionActual);
    int indiceSeparadorImg = billetesImg.indexOf(separador, posicionActual2);
    //si se pasa a -1 rompe el bucle para que no de error
    if (indiceSeparadorCantidad == -1 || indiceSeparadorImg == -1) {
                break;
            }
    String billeteImg = billetesImg.substring(posicionActual2, indiceSeparadorImg);
    String cantidadBilletes = numeroBilletes.substring(posicionActual, indiceSeparadorCantidad);
%>
<div class="billetes">
<img src="<%= request.getContextPath() %>/IMG/<%= billeteImg %>" alt="alt"/>
<p> <%= cantidadBilletes %>  </p>
</div>
<%
    posicionActual = indiceSeparadorCantidad + separador.length();
    posicionActual2 = indiceSeparadorImg + separador.length();
}

if(puedeComprar){
%>
<p><%= mensaje %></p>
<% }else{ %>
<div class="total">
        <p>Total de vuelta:</p>
        <p><%= cambio %> EUR</p>
</div>
<% } %>
<input type="button" value="Volver" onClick="location.href='<%= request.getContextPath() %>/index.html';">
</div>

</body>
</html>