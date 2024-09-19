import ballerina/grpc;
import ballerina/protobuf;

public const string GRPC_DESC = "0A0A677270632E70726F746F120873686F7070696E6722400A1141646450726F6475637452657175657374122B0A0770726F6475637418012001280B32112E73686F7070696E672E50726F64756374520770726F6475637422660A1450726F647563745570646174655265717565737412210A0C70726F647563745F636F6465180120012809520B70726F64756374436F6465122B0A0770726F6475637418022001280B32112E73686F7070696E672E50726F64756374520770726F6475637422370A1452656D6F766550726F6475637452657175657374121F0A0B70726F647563745F736B75180120012809520A70726F64756374536B7522370A1453656172636850726F6475637452657175657374121F0A0B70726F647563745F736B75180120012809520A70726F64756374536B75223D0A10416464546F436172745265717565737412170A07757365725F6964180120012809520675736572496412100A03736B751802200128095203736B7522270A0C4F726465725265717565737412170A07757365725F6964180120012809520675736572496422600A0B557365725265717565737412170A07757365725F69641801200128095206757365724964121B0A09757365725F6E616D651802200128095208757365724E616D65121B0A09757365725F726F6C65180320012809520875736572526F6C65224D0A1241646450726F64756374526573706F6E7365121D0A0A70726F647563745F6964180120012809520970726F64756374496412180A076D65737361676518022001280952076D65737361676522500A1550726F64756374557064617465526573706F6E7365121D0A0A70726F647563745F6964180120012809520970726F64756374496412180A076D65737361676518022001280952076D65737361676522310A1552656D6F766550726F64756374526573706F6E736512180A076D65737361676518012001280952076D65737361676522440A1350726F647563744C697374526573706F6E7365122D0A0870726F647563747318012003280B32112E73686F7070696E672E50726F64756374520870726F647563747322440A1553656172636850726F64756374526573706F6E7365122B0A0770726F6475637418012001280B32112E73686F7070696E672E50726F64756374520770726F64756374225C0A11416464546F43617274526573706F6E7365122D0A0870726F647563747318012003280B32112E73686F7070696E672E50726F64756374520870726F647563747312180A076D65737361676518022001280952076D65737361676522730A0D4F72646572526573706F6E736512190A086F726465725F696418012001280952076F726465724964122D0A0870726F647563747318022003280B32112E73686F7070696E672E50726F64756374520870726F647563747312180A076D65737361676518032001280952076D65737361676522280A0C55736572526573706F6E736512180A076D65737361676518012001280952076D657373616765228E020A0750726F64756374121D0A0A70726F647563745F6964180120012809520970726F64756374496412210A0C70726F647563745F6E616D65180220012809520B70726F647563744E616D65122F0A1370726F647563745F6465736372697074696F6E180320012809521270726F647563744465736372697074696F6E12230A0D70726F647563745F7072696365180420012802520C70726F64756374507269636512230A0D70726F647563745F73746F636B180520012805520C70726F6475637453746F636B121F0A0B70726F647563745F736B75180620012809520A70726F64756374536B7512250A0E70726F647563745F737461747573180720012809520D70726F6475637453746174757322070A05456D70747932DE040A0F53686F7070696E675365727669636512470A0A41646450726F64756374121B2E73686F7070696E672E41646450726F64756374526571756573741A1C2E73686F7070696E672E41646450726F64756374526573706F6E736512500A0D55706461746550726F64756374121E2E73686F7070696E672E50726F64756374557064617465526571756573741A1F2E73686F7070696E672E50726F64756374557064617465526573706F6E736512500A0D52656D6F766550726F64756374121E2E73686F7070696E672E52656D6F766550726F64756374526571756573741A1F2E73686F7070696E672E52656D6F766550726F64756374526573706F6E736512470A154C697374417661696C61626C6550726F6475637473120F2E73686F7070696E672E456D7074791A1D2E73686F7070696E672E50726F647563744C697374526573706F6E736512500A0D53656172636850726F64756374121E2E73686F7070696E672E53656172636850726F64756374526571756573741A1F2E73686F7070696E672E53656172636850726F64756374526573706F6E736512440A09416464546F43617274121A2E73686F7070696E672E416464546F43617274526571756573741A1B2E73686F7070696E672E416464546F43617274526573706F6E7365123D0A0A506C6163654F7264657212162E73686F7070696E672E4F72646572526571756573741A172E73686F7070696E672E4F72646572526573706F6E7365123E0A0B437265617465557365727312152E73686F7070696E672E55736572526571756573741A162E73686F7070696E672E55736572526573706F6E73652801620670726F746F33";

public isolated client class ShoppingServiceClient {
    *grpc:AbstractClientEndpoint;

    private final grpc:Client grpcClient;

    public isolated function init(string url, *grpc:ClientConfiguration config) returns grpc:Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, GRPC_DESC);
    }

    isolated remote function AddProduct(AddProductRequest|ContextAddProductRequest req) returns AddProductResponse|grpc:Error {
        map<string|string[]> headers = {};
        AddProductRequest message;
        if req is ContextAddProductRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("shopping.ShoppingService/AddProduct", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <AddProductResponse>result;
    }

    isolated remote function AddProductContext(AddProductRequest|ContextAddProductRequest req) returns ContextAddProductResponse|grpc:Error {
        map<string|string[]> headers = {};
        AddProductRequest message;
        if req is ContextAddProductRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("shopping.ShoppingService/AddProduct", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <AddProductResponse>result, headers: respHeaders};
    }

    isolated remote function UpdateProduct(ProductUpdateRequest|ContextProductUpdateRequest req) returns ProductUpdateResponse|grpc:Error {
        map<string|string[]> headers = {};
        ProductUpdateRequest message;
        if req is ContextProductUpdateRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("shopping.ShoppingService/UpdateProduct", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <ProductUpdateResponse>result;
    }

    isolated remote function UpdateProductContext(ProductUpdateRequest|ContextProductUpdateRequest req) returns ContextProductUpdateResponse|grpc:Error {
        map<string|string[]> headers = {};
        ProductUpdateRequest message;
        if req is ContextProductUpdateRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("shopping.ShoppingService/UpdateProduct", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <ProductUpdateResponse>result, headers: respHeaders};
    }

    isolated remote function RemoveProduct(RemoveProductRequest|ContextRemoveProductRequest req) returns RemoveProductResponse|grpc:Error {
        map<string|string[]> headers = {};
        RemoveProductRequest message;
        if req is ContextRemoveProductRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("shopping.ShoppingService/RemoveProduct", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <RemoveProductResponse>result;
    }

    isolated remote function RemoveProductContext(RemoveProductRequest|ContextRemoveProductRequest req) returns ContextRemoveProductResponse|grpc:Error {
        map<string|string[]> headers = {};
        RemoveProductRequest message;
        if req is ContextRemoveProductRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("shopping.ShoppingService/RemoveProduct", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <RemoveProductResponse>result, headers: respHeaders};
    }

    isolated remote function ListAvailableProducts(Empty|ContextEmpty req) returns ProductListResponse|grpc:Error {
        map<string|string[]> headers = {};
        Empty message;
        if req is ContextEmpty {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("shopping.ShoppingService/ListAvailableProducts", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <ProductListResponse>result;
    }

    isolated remote function ListAvailableProductsContext(Empty|ContextEmpty req) returns ContextProductListResponse|grpc:Error {
        map<string|string[]> headers = {};
        Empty message;
        if req is ContextEmpty {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("shopping.ShoppingService/ListAvailableProducts", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <ProductListResponse>result, headers: respHeaders};
    }

    isolated remote function SearchProduct(SearchProductRequest|ContextSearchProductRequest req) returns SearchProductResponse|grpc:Error {
        map<string|string[]> headers = {};
        SearchProductRequest message;
        if req is ContextSearchProductRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("shopping.ShoppingService/SearchProduct", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <SearchProductResponse>result;
    }

    isolated remote function SearchProductContext(SearchProductRequest|ContextSearchProductRequest req) returns ContextSearchProductResponse|grpc:Error {
        map<string|string[]> headers = {};
        SearchProductRequest message;
        if req is ContextSearchProductRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("shopping.ShoppingService/SearchProduct", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <SearchProductResponse>result, headers: respHeaders};
    }

    isolated remote function AddToCart(AddToCartRequest|ContextAddToCartRequest req) returns AddToCartResponse|grpc:Error {
        map<string|string[]> headers = {};
        AddToCartRequest message;
        if req is ContextAddToCartRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("shopping.ShoppingService/AddToCart", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <AddToCartResponse>result;
    }

    isolated remote function AddToCartContext(AddToCartRequest|ContextAddToCartRequest req) returns ContextAddToCartResponse|grpc:Error {
        map<string|string[]> headers = {};
        AddToCartRequest message;
        if req is ContextAddToCartRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("shopping.ShoppingService/AddToCart", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <AddToCartResponse>result, headers: respHeaders};
    }

    isolated remote function PlaceOrder(OrderRequest|ContextOrderRequest req) returns OrderResponse|grpc:Error {
        map<string|string[]> headers = {};
        OrderRequest message;
        if req is ContextOrderRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("shopping.ShoppingService/PlaceOrder", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <OrderResponse>result;
    }

    isolated remote function PlaceOrderContext(OrderRequest|ContextOrderRequest req) returns ContextOrderResponse|grpc:Error {
        map<string|string[]> headers = {};
        OrderRequest message;
        if req is ContextOrderRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("shopping.ShoppingService/PlaceOrder", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <OrderResponse>result, headers: respHeaders};
    }

    isolated remote function CreateUsers() returns CreateUsersStreamingClient|grpc:Error {
        grpc:StreamingClient sClient = check self.grpcClient->executeClientStreaming("shopping.ShoppingService/CreateUsers");
        return new CreateUsersStreamingClient(sClient);
    }
}

public isolated client class CreateUsersStreamingClient {
    private final grpc:StreamingClient sClient;

    isolated function init(grpc:StreamingClient sClient) {
        self.sClient = sClient;
    }

    isolated remote function sendUserRequest(UserRequest message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function sendContextUserRequest(ContextUserRequest message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function receiveUserResponse() returns UserResponse|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, _] = response;
            return <UserResponse>payload;
        }
    }

    isolated remote function receiveContextUserResponse() returns ContextUserResponse|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return {content: <UserResponse>payload, headers: headers};
        }
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.sClient->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.sClient->complete();
    }
}

public isolated client class ShoppingServiceRemoveProductResponseCaller {
    private final grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendRemoveProductResponse(RemoveProductResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextRemoveProductResponse(ContextRemoveProductResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.caller->complete();
    }

    public isolated function isCancelled() returns boolean {
        return self.caller.isCancelled();
    }
}

public isolated client class ShoppingServiceAddToCartResponseCaller {
    private final grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendAddToCartResponse(AddToCartResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextAddToCartResponse(ContextAddToCartResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.caller->complete();
    }

    public isolated function isCancelled() returns boolean {
        return self.caller.isCancelled();
    }
}

public isolated client class ShoppingServiceOrderResponseCaller {
    private final grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendOrderResponse(OrderResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextOrderResponse(ContextOrderResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.caller->complete();
    }

    public isolated function isCancelled() returns boolean {
        return self.caller.isCancelled();
    }
}

public isolated client class ShoppingServiceSearchProductResponseCaller {
    private final grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendSearchProductResponse(SearchProductResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextSearchProductResponse(ContextSearchProductResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.caller->complete();
    }

    public isolated function isCancelled() returns boolean {
        return self.caller.isCancelled();
    }
}

public isolated client class ShoppingServiceProductListResponseCaller {
    private final grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendProductListResponse(ProductListResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextProductListResponse(ContextProductListResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.caller->complete();
    }

    public isolated function isCancelled() returns boolean {
        return self.caller.isCancelled();
    }
}

public isolated client class ShoppingServiceProductUpdateResponseCaller {
    private final grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendProductUpdateResponse(ProductUpdateResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextProductUpdateResponse(ContextProductUpdateResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.caller->complete();
    }

    public isolated function isCancelled() returns boolean {
        return self.caller.isCancelled();
    }
}

public isolated client class ShoppingServiceAddProductResponseCaller {
    private final grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendAddProductResponse(AddProductResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextAddProductResponse(ContextAddProductResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.caller->complete();
    }

    public isolated function isCancelled() returns boolean {
        return self.caller.isCancelled();
    }
}

public isolated client class ShoppingServiceUserResponseCaller {
    private final grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendUserResponse(UserResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextUserResponse(ContextUserResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.caller->complete();
    }

    public isolated function isCancelled() returns boolean {
        return self.caller.isCancelled();
    }
}

public type ContextUserRequestStream record {|
    stream<UserRequest, error?> content;
    map<string|string[]> headers;
|};

public type ContextProductUpdateRequest record {|
    ProductUpdateRequest content;
    map<string|string[]> headers;
|};

public type ContextAddProductResponse record {|
    AddProductResponse content;
    map<string|string[]> headers;
|};

public type ContextOrderRequest record {|
    OrderRequest content;
    map<string|string[]> headers;
|};

public type ContextAddToCartResponse record {|
    AddToCartResponse content;
    map<string|string[]> headers;
|};

public type ContextOrderResponse record {|
    OrderResponse content;
    map<string|string[]> headers;
|};

public type ContextRemoveProductResponse record {|
    RemoveProductResponse content;
    map<string|string[]> headers;
|};

public type ContextAddProductRequest record {|
    AddProductRequest content;
    map<string|string[]> headers;
|};

public type ContextSearchProductRequest record {|
    SearchProductRequest content;
    map<string|string[]> headers;
|};

public type ContextAddToCartRequest record {|
    AddToCartRequest content;
    map<string|string[]> headers;
|};

public type ContextProductListResponse record {|
    ProductListResponse content;
    map<string|string[]> headers;
|};

public type ContextUserResponse record {|
    UserResponse content;
    map<string|string[]> headers;
|};

public type ContextEmpty record {|
    Empty content;
    map<string|string[]> headers;
|};

public type ContextProductUpdateResponse record {|
    ProductUpdateResponse content;
    map<string|string[]> headers;
|};

public type ContextRemoveProductRequest record {|
    RemoveProductRequest content;
    map<string|string[]> headers;
|};

public type ContextSearchProductResponse record {|
    SearchProductResponse content;
    map<string|string[]> headers;
|};

public type ContextUserRequest record {|
    UserRequest content;
    map<string|string[]> headers;
|};

@protobuf:Descriptor {value: GRPC_DESC}
public type ProductUpdateRequest record {|
    string product_code = "";
    Product product = {};
|};

@protobuf:Descriptor {value: GRPC_DESC}
public type OrderRequest record {|
    string user_id = "";
|};

@protobuf:Descriptor {value: GRPC_DESC}
public type AddProductResponse record {|
    string product_id = "";
    string message = "";
|};

@protobuf:Descriptor {value: GRPC_DESC}
public type AddToCartResponse record {|
    Product[] products = [];
    string message = "";
|};

@protobuf:Descriptor {value: GRPC_DESC}
public type Product record {|
    string product_id = "";
    string product_name = "";
    string product_description = "";
    float product_price = 0.0;
    int product_stock = 0;
    string product_sku = "";
    string product_status = "";
|};

@protobuf:Descriptor {value: GRPC_DESC}
public type OrderResponse record {|
    string order_id = "";
    Product[] products = [];
    string message = "";
|};

@protobuf:Descriptor {value: GRPC_DESC}
public type RemoveProductResponse record {|
    string message = "";
|};

@protobuf:Descriptor {value: GRPC_DESC}
public type AddProductRequest record {|
    Product product = {};
|};

@protobuf:Descriptor {value: GRPC_DESC}
public type SearchProductRequest record {|
    string product_sku = "";
|};

@protobuf:Descriptor {value: GRPC_DESC}
public type AddToCartRequest record {|
    string user_id = "";
    string sku = "";
|};

@protobuf:Descriptor {value: GRPC_DESC}
public type ProductListResponse record {|
    Product[] products = [];
|};

@protobuf:Descriptor {value: GRPC_DESC}
public type UserResponse record {|
    string message = "";
|};

@protobuf:Descriptor {value: GRPC_DESC}
public type Empty record {|
|};

@protobuf:Descriptor {value: GRPC_DESC}
public type ProductUpdateResponse record {|
    string product_id = "";
    string message = "";
|};

@protobuf:Descriptor {value: GRPC_DESC}
public type RemoveProductRequest record {|
    string product_sku = "";
|};

@protobuf:Descriptor {value: GRPC_DESC}
public type SearchProductResponse record {|
    Product product = {};
|};

@protobuf:Descriptor {value: GRPC_DESC}
public type UserRequest record {|
    string user_id = "";
    string user_name = "";
    string user_role = "";
|};

