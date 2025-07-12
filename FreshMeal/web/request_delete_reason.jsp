<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Gửi yêu cầu xóa Menu</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body style="background:#f0f7f4;">
    <div class="container mt-5">
        <h3 class="text-danger mb-4">Gửi yêu cầu xóa Menu</h3>
        <form method="post" action="requestdeletemenu">
            <!-- Sửa đúng chỗ này: lấy menuID từ attribute -->
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
