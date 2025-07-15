<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Gửi yêu cầu xóa Menu</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
        <link rel="stylesheet" href="assets/css/request_delete.css"> </head>
    <body>
        <div class="container mt-5">
            <h3 class="text-danger mb-4">Gửi yêu cầu xóa Menu</h3>
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger" role="alert">
                    ${errorMessage}
                </div>
            </c:if>

            <form method="post" action="requestdeletemenu">
                <input type="hidden" name="menuID" value="${menuID}"/>
                <div class="mb-3">
                    <label class="form-label">Lý do xóa:</label>
                    <textarea class="form-control" name="reason" required rows="3" placeholder="Nhập lý do bạn muốn xóa menu này..."></textarea>
                </div>
                <button type="submit" class="btn btn-danger">Gửi yêu cầu xóa</button>
                <a href="menumanage" class="btn btn-secondary">Hủy</a>
            </form>
        </div>
    </body>
</html>