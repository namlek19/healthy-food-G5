<%@ page import="java.util.*, model.CartItem" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Giỏ hàng - FreshMeal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="assets/css/style.css">
    <style>
        .cart-item {
            transition: all 0.3s ease;
        }
        .cart-item:hover {
            background-color: #f8f9fa;
        }
        .quantity-input {
            width: 80px;
        }
        .product-image {
            width: 100px;
            height: 100px;
            object-fit: cover;
            border-radius: 8px;
        }
        .empty-cart {
            text-align: center;
            padding: 50px 0;
        }
        .empty-cart i {
            font-size: 64px;
            color: #6c757d;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <div class="container mt-5 mb-5">
        <h2 class="mb-4 text-center">Giỏ hàng của bạn</h2>
        <%
            List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
            double total = 0;
            if (cart == null || cart.isEmpty()) {
        %>
            <div class="empty-cart">
                <i class="fas fa-shopping-cart"></i>
                <h3>Giỏ hàng của bạn đang trống</h3>
                <p class="text-muted">Hãy thêm một số món ăn ngon vào giỏ hàng!</p>
                <a href="index.jsp" class="btn btn-primary mt-3">
                    <i class="fas fa-arrow-left me-2"></i>Tiếp tục mua sắm
                </a>
            </div>
        <%
            } else {
        %>
        <form action="UpdateCartServlet" method="post">
            <div class="card shadow-sm">
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead class="table-light">
                                <tr>
                                    <th>Sản phẩm</th>
                                    <th>Giá</th>
                                    <th>Số lượng</th>
                                    <th>Thành tiền</th>
                                    <th></th>
                                </tr>
                            </thead>
                            <tbody>
                            <%
                                for (CartItem item : cart) {
                                    total += item.getTotalPrice();
                            %>
                                <tr class="cart-item">
                                    <td>
                                        <div class="d-flex align-items-center">
                                            <img src="<%=item.getProduct().getImageURL()%>" class="product-image me-3" alt="<%=item.getProduct().getName()%>">
                                            <div>
                                                <h6 class="mb-0"><%=item.getProduct().getName()%></h6>
                                                <small class="text-muted">Mã sản phẩm: <%=item.getProduct().getProductID()%></small>
                                            </div>
                                        </div>
                                    </td>
                                    <td class="align-middle"><%=String.format("%,.0f", item.getProduct().getPrice())%>₫</td>
                                    <td class="align-middle">
                                        <div class="input-group quantity-input">
                                            <button type="button" class="btn btn-outline-secondary btn-sm" onclick="decreaseQuantity(this)">-</button>
                                            <input type="number" name="quantity_<%=item.getProduct().getProductID()%>" 
                                                   value="<%=item.getQuantity()%>" min="1" class="form-control text-center" />
                                            <button type="button" class="btn btn-outline-secondary btn-sm" onclick="increaseQuantity(this)">+</button>
                                        </div>
                                    </td>
                                    <td class="align-middle"><%=String.format("%,.0f", item.getTotalPrice())%>₫</td>
                                    <td class="align-middle">
                                        <a href="RemoveCartItemServlet?pid=<%=item.getProduct().getProductID()%>" 
                                           class="btn btn-outline-danger btn-sm" onclick="return confirm('Bạn có chắc muốn xóa sản phẩm này?')">
                                            <i class="fas fa-trash"></i>
                                        </a>
                                    </td>
                                </tr>
                            <%
                                }
                            %>
                            </tbody>
                        </table>
                    </div>
                    
                    <div class="d-flex justify-content-between align-items-center mt-4">
                        <div>
                            <a href="index.jsp" class="btn btn-outline-primary">
                                <i class="fas fa-arrow-left me-2"></i>Tiếp tục mua sắm
                            </a>
                        </div>
                        <div class="text-end">
                            <h5 class="mb-3">Tổng cộng: <span class="text-primary"><%=String.format("%,.0f", total)%>₫</span></h5>
                            <div class="d-flex gap-2">
                                <button type="submit" class="btn btn-outline-primary">
                                    <i class="fas fa-sync-alt me-2"></i>Cập nhật giỏ hàng
                                </button>
                                <a href="checkout.jsp" class="btn btn-success">
                                    <i class="fas fa-credit-card me-2"></i>Tiến hành đặt hàng
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </form>
        <% } %>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function increaseQuantity(button) {
            const input = button.previousElementSibling;
            input.value = parseInt(input.value) + 1;
        }

        function decreaseQuantity(button) {
            const input = button.nextElementSibling;
            if (parseInt(input.value) > 1) {
                input.value = parseInt(input.value) - 1;
            }
        }
    </script>
</body>
</html>
