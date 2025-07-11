<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Quản lý Thực Đơn</title>
        <link rel="stylesheet" href="assets/css/blog.css">
        <link rel="stylesheet" href="assets/css/menu_manage.css">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    </head>
    <body style="background: #f0f7f4;">
        <%@ include file="sidebar.jsp" %>

        <div class="main-container">
            <h2 class="text-success fw-bold mb-4">Quản Lý Menu Cá Nhân</h2>

            <table class="table table-bordered table-hover shadow-sm bg-white">
                <thead class="table-success text-center">
                    <tr>
                        <!--<th>Ảnh</th>-->
                        <th>Tên Menu</th>
                        <th>Nhóm BMI</th>
                        <th>Món ăn</th>
                        <th>Trạng thái</th>
                        <th>Thao tác</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="m" items="${menuList}">
                        <tr class="align-middle text-center">
                            <!--<td><img src="${m.imageURL}" width="80" style="border-radius: 8px;"></td>-->
                            <td>${m.menuName}</td>
                            <td>${m.bmiCategory}</td>
                            <td><c:out value="${productNamesMap[m.menuID]}" escapeXml="false" /></td>
                            <td>
                                <c:set var="status" value="${statusMap[m.menuID]}" />

                                <c:choose>
                                    <c:when test="${status == 0}">
                                        <span class="badge text-bg-danger">Bị từ chối</span>
                                    </c:when>
                                    <c:when test="${status == 1}">
                                        <span class="badge text-bg-warning">Chờ duyệt</span>
                                    </c:when>
                                    <c:when test="${status == 2}">
                                        <span class="badge text-bg-info">Đã duyệt</span>
                                    </c:when>
                                    <c:when test="${status == 3}">
                                        <span class="badge text-bg-success">Đã đăng</span>
                                    </c:when>
                                    <c:when test="${status == 4}">
                                        <span class="badge bg-dark">Chờ yêu cầu xóa</span>
                                    </c:when>
                                </c:choose>
                            </td>
                            <td>
                                <c:if test="${status == 1}">
                                    <a href="deletemenu?id=${m.menuID}" class="btn btn-sm btn-outline-danger" onclick="return confirm('Bạn có chắc chắn muốn xóa?');">Xóa</a>
                                </c:if>
                                <c:if test="${status == 3}">
                                    <a href="requestdeletemenu?id=${m.menuID}" class="btn btn-sm btn-outline-warning" onclick="return confirm('Gửi yêu cầu xóa menu này?');">Gửi yêu cầu xóa</a>
                                </c:if>
                                <c:if test="${status == 0}">
                                    <a href="deletemenu?id=${m.menuID}" class="btn btn-sm btn-outline-danger" onclick="return confirm('Bạn có chắc chắn muốn xóa?');">Xóa</a>
                                </c:if>
                                <c:if test="${status != 1 && status != 3 && status != 0}">
                                    <span class="text-muted">--</span>
                                </c:if>
                            </td>

                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </body>
</html>
