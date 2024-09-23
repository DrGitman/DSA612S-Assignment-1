import ballerina/grpc;
import ballerina/io;
import ballerina/time;

map<Product> productStore = {};

map<UserRequest> userStore= {};

 Product[] availableProducts = [];


listener grpc:Listener ep = new (9090);

@grpc:Descriptor {value: GRPC_DESC}
service "ShoppingService" on ep {

    remote function AddProduct(AddProductRequest request) returns AddProductResponse|error {
        Product product = request.product;
        productStore[product.product_id] = product;
        return {product_id:product.product_id ,message: "Product added successfully"};
   
}
 remote function UpdateProduct(ProductUpdateRequest value) returns ProductUpdateResponse|error {
        string requestedUser = value.user_id;


        //check if the user exists
        foreach var user in userStore {
            if user.user_role != "admin" && user.user_id== requestedUser{
            return error("Only admin users are allowed to update products.");
            
            }
        }


    // Iterate through the productStore to find the product by product_id

    Product? matchedProduct = ();

    foreach var product in productStore {
        if product.product_id == value.product.product_id {
            matchedProduct = product;
            break; // Exit the loop once the product is found
        }
    }

    if matchedProduct is Product {
        // Update the product fields with the provided values
        matchedProduct.product_name = value.product.product_name;
        matchedProduct.product_description = value.product.product_description;
        matchedProduct.product_price = value.product.product_price;
        matchedProduct.product_stock = value.product.product_stock;
        matchedProduct.product_sku = value.product.product_sku;
        matchedProduct.product_status = value.product.product_status;

        // Update the product in the productStore
        productStore[matchedProduct.product_id] = matchedProduct;

        // Return a success message
        ProductUpdateResponse response = {
            message: "Product updated successfully."
        };
        return response;
    } else {
        // If the product does not exist, return an error
        return error("Product not found for the provided product_id.");
    }
        
    }

    remote function RemoveProduct(RemoveProductRequest value) returns RemoveProductResponse|error {
    }

    // Customer operations
remote function ListAvailableProducts(Empty value) returns ProductListResponse|error {
    // Create a list to hold available products
    Product[] availableProducts = [];

    // Iterate over the productStore map to find available products
    foreach var product in productStore {
        if product.product_status == "available" && product.product_stock > 0 {
            availableProducts.push(product);
        }
    }
    // Return the available products
    return { products: availableProducts };
    }

        remote function SearchProduct(SearchProductRequest value) returns SearchProductResponse|error {
    // Get the SKU from the request
    string requestedSku = value.product_sku;

    // Iterate over the productStore map to find a product by SKU
    foreach var product in productStore {
        if product.product_sku == requestedSku {
            // If the product is found, return the product's details
            return {product: product};
        }
    }
    // Return an error if the product is not found
    return error("Product not available for the provided SKU.");
    }

    remote function AddToCart(AddToCartRequest value) returns AddToCartResponse|error {
    }

    remote function PlaceOrder(OrderRequest value) returns OrderResponse|error {

        
        string product_id = value.product_id;

        // Check if the user has a cart


        if userCart.length() == 0 {
            return {message: "Cart is empty. Cannot place an order."};
        }

        // Create a unique order ID (for simplicity, using the user ID and timestamp)
        string orderId = "ORDER_" + product_id + "_" + time:utcNow().toString();

        // Iterate over the user's cart and reduce stock
        Product[] orderedProducts = [];
        foreach Product product in userCart {
            // Check product availability
            Product? storedProduct = productStore[product.product_id];
            if storedProduct is Product && storedProduct.product_stock > 0 {
                storedProduct.product_stock -= 1; // Reduce the stock by 1
                productStore[product.product_id] = storedProduct; // Update the productStore
                orderedProducts.push(product); // Add the product to the order
            }
        }

        // Clear the user's cart after placing the order
        userCarts[product_id] = [];

        // Return the order response with ordered products
        return {order_id: orderId, products: orderedProducts, message: "Order placed successfully"};
    }


        //Create multiple users via streaming
    remote function CreateUsers(stream<UserRequest, grpc:Error?> clientStream) returns UserResponse|error {
        int usersCreated = 0;
        UserRequest[] createdUsers = [];

        grpc:Error? streamError = clientStream.forEach(function(UserRequest userReq) {
            userStore[userReq.user_id] = userReq;
            createdUsers.push(userReq);
            usersCreated += 1;
        });

        if streamError is grpc:Error {
            return streamError;
        }

        UserResponse response = {
            message: "Users successfully created."
        };

        return response;
    }
}

