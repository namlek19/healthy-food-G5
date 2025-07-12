<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dal.MenuDAO, model.Menu, java.util.List, model.Product" %>
<%
    int menuID = Integer.parseInt(request.getParameter("menuID"));
    MenuDAO dao = new MenuDAO();
    Menu menu = dao.getMenuById(menuID);
    List<Product> allProducts = dao.getAllProducts(); // lấy tất cả sản phẩm
    List<Integer> selectedProductIDs = dao.getProductIDsByMenu(menuID); // lấy id sản phẩm đang có trong menu
%>
<!DOCTYPE html>
<html>
    <head>
        <title>Yêu cầu sửa Menu</title>
        <link rel="stylesheet" href="assets/css/blog.css">
        <link rel="stylesheet" href="assets/css/menu_post.css">
        <link rel="stylesheet" href="assets/css/request_edit_menu.css">

        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    </head>
    <body style="background: #f0f7f4;">
        <%@ include file="sidebar.jsp" %>
        <div class="main-container">
            <h2 class="text-success mb-4" style="font-weight:700;">Yêu cầu sửa Menu ID <%=menuID%></h2>

            <form action="requestEditMenu" method="post" id="editMenuForm">
                <input type="hidden" name="menuID" value="<%=menuID%>">

                <div class="mb-4">
                    <div class="card p-3 shadow-sm">
                        <h5 class="fw-bold mb-3">Các món đã chọn</h5>
                        <table class="table selected-products-table align-middle">
                            <thead>
                                <tr class="table-success">
                                    <th style="width: 5%;">STT</th>
                                    <th>Tên món</th>
                                    <th>Calories</th>
                                    <th>Giá</th>
                                    <th></th>
                                </tr>
                            </thead>
                            <tbody id="selectedProductsTableBody">
                                <% int index=1;
                                for(Product p : allProducts){
                                    if(selectedProductIDs.contains(p.getProductID())){ %>
                                <tr id="row<%=p.getProductID()%>">
                                    <td><%=index++%></td>
                                    <td><%=p.getName()%></td>
                                    <td><%=p.getCalories()%></td>
                                    <td><%=p.getPrice()%></td>
                                    <td>
                                        <button type="button" onclick="removeProduct(<%=p.getProductID()%>)" class="btn btn-sm btn-outline-danger">Xóa</button>
                                    </td>
                                </tr>
                                <% }} %>
                            </tbody>
                        </table>
                        <input type="hidden" name="selectedProductIDs" id="selectedProductIDs" 
                               value="<%=selectedProductIDs.toString().replaceAll("[\\[\\] ]","")%>">
                    </div>
                </div>

                <div class="card p-4 mb-4 shadow-sm">
                    <div class="row mb-3">
                        <div class="col-md-6 mb-2">
                            <label class="form-label fw-bold">Tên thực đơn</label>
                            <input class="form-control" name="menuName" required maxlength="60" value="<%=menu.getMenuName()%>">
                        </div>
                        <div class="col-md-6 mb-2">
                            <label class="form-label fw-bold">Nhóm BMI phù hợp</label>
                            <select class="form-select" name="bmiCategory" required>
                                <option value="">Chọn nhóm BMI</option>
                                <option value="Underweight" <%=menu.getBmiCategory().equals("Underweight")?"selected":""%>>Gầy (Underweight)</option>
                                <option value="Normal" <%=menu.getBmiCategory().equals("Normal")?"selected":""%>>Bình thường (Normal)</option>
                                <option value="Overweight" <%=menu.getBmiCategory().equals("Overweight")?"selected":""%>>Thừa cân (Overweight)</option>
                                <option value="Obese" <%=menu.getBmiCategory().equals("Obese")?"selected":""%>>Béo phì (Obese)</option>
                            </select>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold">Mô tả thực đơn</label>
                        <textarea class="form-control" name="description" rows="3" maxlength="300" required><%=menu.getDescription()%></textarea>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold">Ảnh thực đơn</label>
                        <div class="image-upload-wrapper" id="editMenuImageDropArea" title="Nhấn, kéo thả hoặc Ctrl+V để chọn ảnh">
                            <span class="plus-icon" id="editMenuPlusIcon">+</span>
                            <input type="file" id="editMenuImageInput" accept="image/*" style="display:none;">
                            <img id="editMenuPreviewImage" src="<%=menu.getImageURL()%>" 
                                 style="max-width:160px; max-height:160px; border-radius:8px; margin-top:5px; display:block;" />
                        </div>
                        <input type="hidden" name="imageURL" id="editMenuImageURL" value="<%=menu.getImageURL()%>">
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-bold">Lý do sửa</label>
                        <textarea class="form-control" name="reason" placeholder="Nhập lý do gửi yêu cầu sửa..." required></textarea>
                    </div>
                    <button type="submit" class="btn btn-success btn-lg w-100 mt-2 fw-bold" style="font-size:1.15em;">
                        Gửi yêu cầu sửa
                    </button>
                </div>
            </form>

            <div class="mt-4">
                <h4 class="mb-3 fw-bold text-success">Chọn thêm món</h4>
                <div class="row">
                    <% for(Product p : allProducts){
                if(!selectedProductIDs.contains(p.getProductID())){ %>
                    <div class="col-md-3 mb-3 d-flex">
                        <div class="product-card w-100 d-flex flex-column justify-content-between">
                            <img src="<%=p.getImageURL()%>" alt="<%=p.getName()%>">
                            <div class="fw-bold"><%=p.getName()%></div>
                            <div class="small text-secondary mb-1">
                                <%=p.getCalories()%> kcal | 
                                <span class="text-success"><%=p.getPrice()%> VNĐ</span>
                            </div>
                            <button type="button" id="btnSelect<%=p.getProductID()%>"
                                    onclick="selectProduct(<%=p.getProductID()%>,
                                                    '<%=p.getName().replace("'","\\'")%>',
                                                    '<%=p.getImageURL().replace("'","\\'")%>',
                                    <%=p.getCalories()%>,
                                    <%=p.getPrice()%>)"
                                    class="btn btn-sm btn-outline-success">Chọn</button>
                        </div>
                    </div>
                    <% }} %>
                </div>
            </div>
        </div>

        <script src="js/request_edit_menu_script.js"></script>

    </body>
</html>
