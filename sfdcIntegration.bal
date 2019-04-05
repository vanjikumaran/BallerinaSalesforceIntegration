import wso2/sfdc37 as sf;
import ballerina/http;
import ballerina/io;
import ballerina/config;
import ballerina/log;

sf:SalesforceConfiguration salesforceConfig = {
        baseUrl: config:getAsString("SF_URL"),
        clientConfig: {
            auth: {
                scheme: http:OAUTH2,
                accessToken: config:getAsString("SF_ACCESS_TOKEN"),
                //refreshToken: config:getAsString("SF_REFRESH_TOKEN"),
                clientId: config:getAsString("SF_CLIENT_ID"),
                clientSecret: config:getAsString("SF_CLIENT_SECRET")
                //refreshUrl: config:getAsString("SF_REFRESH_URL")
            }
        }
};

sf:Client salesforceClient = new(salesforceConfig);


http:ServiceEndpointConfiguration httpEndpointConfiguration = {
    // secureSocket: {
    //     keyStore: {
    //         path: "${ballerina.home}/bre/security/ballerinaKeystore.p12",
    //         password: "ballerina"
    //     }
    // }
};

listener http:Listener httpInboundEP = new(9090, config = httpEndpointConfiguration);




//Book API Service
@http:ServiceConfig {
    basePath:"/books"
}
service BookAPI on httpInboundEP{
    @http:ResourceConfig {
        methods: ["GET"],
        path: "/book/{id}"        
    }
    resource function getBook(http:Caller caller, http:Request request, string id ) {
        string searchQueryByBookID = "SELECT Book_Number__c,Id,Name,Status__c,Book_Name_in_English__c,Book_Title__c FROM Book__c WHERE Name ='"+ id +"'";
        var response = salesforceClient->getQueryResult(searchQueryByBookID);
        if (response is json) {
            io:println("TotalSize:  ", response["totalSize"]);
            io:println("Done:  ", response["done"]);
            io:println("Records: ", response["records"]);
            io:println("Message: ", response.message);

            var result = caller->respond(response);
            if (result is error) {
            log:printError("Error sending response", err = result);
        }
        } else {
            io:println("Error: ", response.message);
        }        
    }
}

















// service members on httpInboundEP {
//     @http:ResourceConfig {
//         methods: ["GET"],
//         path: "/member/{phoneNumber}"
//     }
//     resource function searchMemberByPhonenumber(http:Caller caller, http:Request request, string phoneNumber) {
//         string searchQueryForSearchMemberByPhonenumber = "SELECT Contact_Number__c, Email_Id__c, Id,Name,Name__c,Students_Name__c FROM Member__c WHERE Contact_Number__c ='(925) 464-6816'" ;
//         var response = salesforceClient->getQueryResult(searchQueryForSearchMemberByPhonenumber);
//         if (response is json) {
//             io:println("TotalSize:  ", response["totalSize"]);
//             io:println("Done:  ", response["done"]);
//             io:println("Records: ", response["records"]);
//             io:println("Message: ", response.message);
//         } else {
//             io:print("SF error: ", response.salesforceErrors);  
//             io:println("Error: ", response.message);
//         }
//     }

//     // @http:ResourceConfig {
//     //     methods: ["POST"],
//     //     path: "/member"
//     // }
//     // resource function addNewMembers(http:Caller caller, http:Request request) {

//     // }

//     // @http:ResourceConfig {
//     //     methods: ["PUT"],
//     //     path: "/member"
//     // }
//     // resource function updateMember(http:Caller caller, http:Request request) {

//     // }


// }










// service lending on httpInboundEP{
    
//     @http:ResourceConfig {
//         methods: ["POST"],
//         path: "/lending/new"
//     }
//     resource function addLending(http:Caller caller, http:Request request) {
        
//     }


// }