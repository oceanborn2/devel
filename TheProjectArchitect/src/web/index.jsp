<%@ page info="The Project Architect main page" %>

<html>
<head><title>Welcome to the Project Architect</title></head>

<body>
<%@ include file="header.jsp" %>


<table border=2 colspan=4>
<tr><td>Projects</td><td>
<input type="submit" name="create_project" value="Create"/>
<input type="submit" name="edit_project" value="Edit"/>
<input type="submit" name="find_project" value="Find"/>
<input type="submit" name="delete_project" value="Delete"/>
</td></tr>

<tr><td>Documents</td><td>
<input type="submit" name="create_document" value="Create"/>
<input type="submit" name="edit_document" value="Edit"/>
<input type="submit" name="find_document" value="Find"/>
<input type="submit" name="delete_document" value="Delete"/>
</td></tr>
</table>

<%@ include file="footer.jsp" %>
</body>

</html>
