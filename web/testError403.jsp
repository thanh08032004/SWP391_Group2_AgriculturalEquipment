<%-- 
    Document   : testError403
    Created on : 10 Jan 2026, 15:40:04
    Author     : FPT
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
      <% 
    response.sendError(403); 
%>
    </body>
</html>
