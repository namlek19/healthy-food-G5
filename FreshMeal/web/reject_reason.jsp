<%@ page contentType="text/html;charset=UTF-8" %>
<%
    int menuId = (Integer) request.getAttribute("menuId");
    String action = (String) request.getAttribute("action");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Nhập lý do từ chối</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f0f8f4;
            color: #333;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        form {
            background: #ffffff;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            max-width: 400px;
            width: 100%;
        }
        h2 {
            text-align: center;
            color: #2e7d32;
            margin-bottom: 20px;
        }
        label {
            display: block;
            margin-bottom: 8px;
            color: #4caf50;
            font-weight: 600;
        }
        textarea {
            width: 100%;
            height: 100px;
            border: 2px solid #c8e6c9;
            border-radius: 8px;
            padding: 10px;
            resize: vertical;
            font-size: 14px;
            transition: border-color 0.3s;
        }
        textarea:focus {
            border-color: #66bb6a;
            outline: none;
        }
        button, .btn-cancel {
            display: inline-block;
            margin-top: 15px;
            padding: 10px 20px;
            border: none;
            border-radius: 8px;
            text-decoration: none;
            color: white;
            font-size: 14px;
            cursor: pointer;
            transition: background-color 0.3s;
        }
        button {
            background-color: #4caf50;
        }
        button:hover {
            background-color: #43a047;
        }
        .btn-cancel {
            background-color: #9e9e9e;
            margin-left: 10px;
        }
        .btn-cancel:hover {
            background-color: #757575;
        }
    </style>
</head>
<body>
    <form action="rejectMenuReason" method="post">
        <input type="hidden" name="menuId" value="${param.menuId}" />
        <input type="hidden" name="action" value="${param.action}" />
        <h2>Nhập lý do từ chối</h2>
        <label>Nhập lý do từ chối:</label>
        <textarea name="reason" required></textarea><br>
        <button type="submit">Gửi</button>
        <a href="pending-menu.jsp" class="btn-cancel">Hủy</a>
    </form>
</body>
</html>
