let selectedProducts = [];
            let selectedProductInfo = {}; // {productID: {name, img, calo, price}}
            function selectProduct(id, name, img, calo, price) {
                id = Number(id);
                if (!selectedProducts.includes(id)) {

                    // Xử lý an toàn cho giá trị calories
                    let finalCalo = Number(calo);
                    if (isNaN(finalCalo)) {
                        finalCalo = 0;
                    }

                    selectedProducts.push(id);
                    selectedProductInfo[id] = {
                        name: name,
                        img: img,
                        calo: finalCalo,
                        price: Number(price)
                    };
                    renderSelectedTable();
                    document.getElementById('btnSelect' + id).disabled = true;
                }
            }
            function removeProduct(id) {
                id = Number(id);
                selectedProducts = selectedProducts.filter(x => x != id);
                delete selectedProductInfo[id];
                renderSelectedTable();
                let btn = document.getElementById('btnSelect' + id);
                if (btn)
                    btn.disabled = false;
            }
            function renderSelectedTable() {
                let body = document.getElementById('selectedProductsTableBody');
                body.innerHTML = '';
                if (selectedProducts.length === 0) {
                    body.innerHTML = `<tr id="noSelectedRow"><td colspan="5" class="text-secondary">Chưa chọn món nào!</td></tr>`;
                } else {
                    selectedProducts.forEach((id, index) => {
                        let p = selectedProductInfo[id];
                        if (!p)
                            return;
                        let newRow = body.insertRow();
                        let cellIndex = newRow.insertCell(0);
                        cellIndex.textContent = index + 1;
                        cellIndex.style.fontWeight = 'bold';
                        let cellName = newRow.insertCell(1);
                        cellName.textContent = p.name;
                        let cellCalo = newRow.insertCell(2);
                        cellCalo.textContent = p.calo + " kcal";
                        let cellPrice = newRow.insertCell(3);
                        let price = Number(p.price);
                        let priceStr = (isNaN(price) ? '0' : price.toLocaleString('vi-VN')) + " VNĐ";
                        cellPrice.textContent = priceStr;
                        let cellRemove = newRow.insertCell(4);
                        let removeButton = document.createElement('button');
                        removeButton.type = 'button';
                        removeButton.className = 'btn btn-danger btn-sm';
                        removeButton.textContent = 'X';
                        removeButton.onclick = function () {
                            removeProduct(id);
                        };
                        cellRemove.appendChild(removeButton);
                    });
                }

                document.getElementById('selectedProductIDs').value = selectedProducts.join(',');
            }