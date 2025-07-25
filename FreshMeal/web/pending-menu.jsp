<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="dal.MenuDAO, java.util.*, model.Menu, model.Product, model.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    MenuDAO dao = new MenuDAO();
    List<Menu> pendingMenus = dao.getMenusByStatus(1);
    List<Menu> deleteRequests = dao.getMenusByStatus(4);

    String successMsg = (String) session.getAttribute("successMsg");
    String errorMsg   = (String) session.getAttribute("errorMsg");
    if (successMsg != null) session.removeAttribute("successMsg");
    if (errorMsg   != null) session.removeAttribute("errorMsg");
%>
<!DOCTYPE html>
<html>
    <head>
        <title>Menu chờ duyệt | Quản lý</title>
        <link rel="stylesheet" href="assets/css/pendingmanager.css?v=2">
        <meta name="viewport" content="width=device-width, initial-scale=1">
    </head>
    <body>

        <header class="manager-header">
            <div class="container">
                <div class="logo">
                    <img src="assets/images/logotext.png" alt="logo" />
                </div>
                <div class="header-title">Menu chờ duyệt</div>
                <div class="header-right">
                    <span class="username">
                        Xin chào, <b><%= user.getFullName() %></b>
                    </span>
                    <a href="login?action=logout" class="btn-logout">Đăng xuất</a>
                </div>
            </div>
        </header>

        <div class="container-main">

            <% if (successMsg != null) { %>
            <div class="success-msg"><%= successMsg %></div>
            <% } %>
            <% if (errorMsg != null) { %>
            <div class="error-msg"><%= errorMsg %></div>
            <% } %>

            <h2>Danh sách Menu chờ duyệt</h2>
            <table class="table-menus">
                <tr>
                    <th>STT</th>
                    <th>Tên Menu</th>
                    <th>Sản phẩm</th>
                    <th>Mô tả</th>
                    <th>Nutritionist</th>
                    <th>Tổng giá</th>
                    <th>Thao tác</th>
                </tr>
                <% int stt = 1; for (Menu m : pendingMenus) { %>
                <tr>
                    <td><%= stt++ %></td>
                    <td><%= m.getMenuName() %></td>
                    <td class="product-list">
                        <% for (Product p : m.getProducts()) { %>
                        <div class="prod-item">
                            <img src="<%= p.getImageURL() %>" alt="<%= p.getName() %>" />
                            <div class="prod-info">
                                <span class="prod-name"><%= p.getName() %></span>
                                <span class="prod-price"><%= String.format("%,.0f ₫", p.getPrice()) %></span>
                            </div>
                        </div>
                        <% } %>
                    </td>
                    <td><%= m.getDescription() %></td>
                    <td><%= m.getNutritionistID() %></td>
                    <td class="tot-price"><%= String.format("%,.0f ₫", m.getTotalPrice()) %></td>
                    <td>
                        <form action="approveMenu" method="post" style="display:inline">
                            <input type="hidden" name="menuId" value="<%= m.getMenuID() %>" />
                            <input type="hidden" name="action" value="approve" />
                            <button type="submit" class="btn-approve" onclick="return confirm('Bạn chắc chắn DUYỆT menu này?')">Duyệt</button>
                        </form>
                        <form action="rejectMenuReason" method="get" style="display:inline">
                            <input type="hidden" name="menuId" value="<%= m.getMenuID() %>" />
                            <input type="hidden" name="action" value="reject" /> 
                            <button type="submit" class="btn-reject" onclick="return confirm('Bạn muốn TỪ CHỐI menu này?')">Từ chối</button>
                        </form>

                    </td>
                </tr>
                <% } %>
            </table>

            <% if (pendingMenus == null || pendingMenus.isEmpty()) { %>
            <div style="margin-top:20px;color:#189654;font-weight:600;">Không có menu nào đang chờ duyệt.</div>
            <% } %>

            <h2 style="margin-top: 50px;">Danh sách Menu yêu cầu xóa</h2>
            <table class="table-menus">
                <tr>
                    <th>STT</th>
                    <th>Tên Menu</th>
                    <th>Sản phẩm</th>
                    <th>Mô tả</th>
                    <th>Nutritionist</th>
                    <th>Tổng giá</th>
                    <th>Thao tác</th>
                </tr>
                <% int stt2 = 1; for (Menu m : deleteRequests) { %>
                <tr>
                    <td><%= stt2++ %></td>

                    <td><%= m.getMenuName() %></td>
                    <td class="product-list">
                        <% for (Product p : m.getProducts()) { %>
                        <div class="prod-item">
                            <img src="<%= p.getImageURL() %>" alt="<%= p.getName() %>" />
                            <div class="prod-info">
                                <span class="prod-name"><%= p.getName() %></span>
                                <span class="prod-price"><%= String.format("%,.0f ₫", p.getPrice()) %></span>
                            </div>
                        </div>
                        <% } %>
                    </td>
                    <td><%= m.getDescription() %></td>
                    <td><%= m.getNutritionistID() %></td>
                    <td class="tot-price"><%= String.format("%,.0f ₫", m.getTotalPrice()) %></td>
                    <td>
                        <form action="approveMenu" method="post" style="display:inline">
                            <input type="hidden" name="menuId" value="<%= m.getMenuID() %>" />
                            <input type="hidden" name="action" value="approveDeleteRequest" />
                            <button type="submit" class="btn-approve" onclick="return confirm('Xác nhận xóa menu này khỏi hệ thống?')">Đồng ý</button>
                        </form>
                        <form action="rejectMenuReason" method="get" style="display:inline">
                            <input type="hidden" name="menuId" value="<%= m.getMenuID() %>" />
                            <input type="hidden" name="action" value="rejectDeleteRequest" />
                            <button type="submit" class="btn-reject" onclick="return confirm('Từ chối xóa, giữ lại menu?')">Từ chối</button>
                        </form>
                    </td>
                </tr>
                <% } %>
            </table>

            <% if (deleteRequests == null || deleteRequests.isEmpty()) { %>
            <div style="margin-top:20px;color:#ff4444;font-weight:600;">Không có yêu cầu xóa nào.</div>
            <% } %>
            <%
                List<Menu> editRequests = dao.getMenusFromSuaMenu(); 
            %>

            <h2 style="margin-top: 50px;">Danh sách Menu yêu cầu sửa</h2>
            <table class="table-menus">
                <tr>
                    <th>STT</th>
                    <th>Tên Menu</th>
                    <th>Sản phẩm</th>
                    <th>Mô tả</th>
                    <th>Nutritionist</th>
                    <th>Thao tác</th>
                </tr>
                <% int stt3 = 1; for (Menu m : editRequests) { %>
                <tr>
                    <td><%= stt3++ %></td>

                    <td><%= m.getMenuName() %></td>
                    <td class="product-list">
                        <% for (Product p : m.getProducts()) { %>
                        <div class="prod-item">
                            <img src="<%= p.getImageURL() %>" alt="<%= p.getName() %>" />
                            <div class="prod-info">
                                <span class="prod-name"><%= p.getName() %></span>
                                <span class="prod-price"><%= String.format("%,.0f ₫", p.getPrice()) %></span>
                            </div>
                        </div>
                        <% } %>
                    </td>
                    <td><%= m.getDescription() %></td>
                    <td><%= m.getNutritionistID() %></td>
                    <td>
                        <form action="approveMenu" method="post" style="display:inline">
                            <input type="hidden" name="menuId" value="<%= m.getMenuID() %>" />
                            <input type="hidden" name="action" value="approveEditRequest" />
                            <button type="submit" class="btn-approve" onclick="return confirm('Đồng ý áp dụng các sửa đổi của menu này?')">Đồng ý</button>
                        </form>
                        <form action="rejectMenuReason" method="get" style="display:inline">
                            <input type="hidden" name="menuId" value="<%= m.getMenuID() %>" />
                            <input type="hidden" name="action" value="rejectEditRequest" />
                            <button type="submit" class="btn-reject" onclick="return confirm('Từ chối sửa đổi của menu này?')">Từ chối</button>
                        </form>
                    </td>
                </tr>
                <% } %>
            </table>

            <% if (editRequests == null || editRequests.isEmpty()) { %>
            <div style="margin-top:20px;color:#888;font-weight:600;">Không có yêu cầu sửa menu nào.</div>
            <% } %>

        </div>
    </body>
</html>
