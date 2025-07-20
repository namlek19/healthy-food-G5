<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
    <head>
        <title>Combo chờ đăng</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    </head>
    <body>
        <jsp:include page="includes/sidebarSeller.jsp" />

        <div class="container" style="margin-left: 270px; padding-top: 30px; width: 1250px">
            <h3 class="mb-4 text-success">Danh sách combo chờ đăng</h3>
            <c:if test="${not empty sessionScope.msg}">
                <div class="alert alert-info">${sessionScope.msg}</div>
                <c:remove var="msg" scope="session"/>
            </c:if>
            <table class="table table-bordered table-hover align-middle">
                <thead class="table-success">
                    <tr>
                        <th>#</th>
                        <th>Tên Combo</th>
                        <th>Người đăng</th>
                        <th>Hành động</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="combo" items="${comboList}" varStatus="loop">
                        <tr>
                            <td>${loop.index + 1}</td>
                            <td>${combo.menuName}</td>
                            <td>${uploaderMap[combo.menuID]}</td>
                            <td>
                                <form action="postCombo" method="post" onsubmit="return confirm('Xác nhận đăng combo này?');">
                                    <input type="hidden" name="menuID" value="${combo.menuID}">
                                    <button type="submit" class="btn btn-outline-success btn-sm"">Đăng</button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>

            <c:if test="${empty comboList}">
                <div class="alert alert-info text-center">Hiện chưa có combo nào đang chờ đăng.</div>
            </c:if>
        </div>

    </body>
</html>