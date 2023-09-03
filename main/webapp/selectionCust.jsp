<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@page import="project.RoomSelection"%>
<%@page import="java.util.List"%>
<%@page import="project.Room"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>All Rooms Available</title>
</head>
<body>
<% 
List<Room> rooms = RoomSelection.roomList();
%>
<h2>All Available rooms:</h2>
<button>Search Rooms</button>
 <div align="center">
        <table border="1" >
            <caption>Rooms</caption>
            <tr>
                <th>ID</th>
                <th>Price</th>
                <th>Amenities</th>
                <th>capacity</th>
                <th>View</th>
                <th>extra bed</th>
                <th>Hotel</th>
            </tr>
            <c:forEach var="room" items="${rooms}">
                <tr>
                    <td><c:out value="${room.getroomID}" /></td>
                    <td><c:out value="${room.price}" /></td>
                    <td><c:out value="${room.amenity}" /></td>
                    <td><c:out value="${room.capacity}" /></td>
                    <td><c:out value="${room.roomView}" /></td>
                    <td><c:out value="${room.extraBed}" /></td>
                    <td><c:out value="${room.hotelID}" /></td>
                </tr>
            </c:forEach>
        </table>
    </div>
</body>
</html>