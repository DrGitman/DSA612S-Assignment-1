import ballerina/http;

public type Course record {
    string courseCode;
    string courseName;
    int nqfLevel;
};

public type Programme record {
    string programmeCode;
    string programmeTitle;
    int nqfLevel;
    string faculty;
    string department;
    string registrationDate;
    Course[] courses;
};

public Programme[] programmes = [];

service /programme on new http:Listener(9090) {

    // Adding a new course and programme
    resource function post addProgramme(http:Caller caller, http:Request req) returns error? {
        json requestBody = check req.getJsonPayload();
        Programme newProgramme = check requestBody.cloneWithType(Programme);

        if (newProgramme.programmeCode == "" || newProgramme.programmeTitle == "") {
            http:Response res = new;
            res.setJsonPayload({ "message": "Invalid data: programmeCode and programmeTitle are required." });
            res.statusCode = http:STATUS_BAD_REQUEST;
            check caller->respond(res);
            return;
        }

        programmes.push(newProgramme);

        http:Response res = new;
        json programmeJson = newProgramme.toJson();
        res.setJsonPayload({ "message": "Programme added successfully.", "programme": programmeJson });
        res.statusCode = http:STATUS_CREATED;
        check caller->respond(res);
    }

            // Retrieve all programmes
    resource function get allProgrammes(http:Caller caller) returns error? {
        check caller->respond(programmes);
    }

    // Update an existing programme based on programmeCode
resource function put updateProgramme(string programmeCode, http:Caller caller, http:Request req) returns error? {
    json requestBody = check req.getJsonPayload();
    Programme updatedProgramme = check requestBody.cloneWithType(Programme);

    // Find the existing programme by programmeCode using a loop
    int? index = ();
    foreach int i in 0...programmes.length() {
        if (programmes[i].programmeCode == programmeCode) {
            index = i;
            break;
        }
    }

    if (index is int) {
        // Update the programme information
        programmes[index] = updatedProgramme;

        http:Response res = new;
        json programmeJson = updatedProgramme.toJson();
        res.setJsonPayload({ "message": "Programme updated successfully.", "programme": programmeJson });
        res.statusCode = http:STATUS_OK;
        check caller->respond(res);
    } else {
        http:Response res = new;
        res.setJsonPayload({ "message": "Programme not found." });
        res.statusCode = http:STATUS_NOT_FOUND;
        check caller->respond(res);
    }
}

    // Resource to delete a programme based on the programmeCode
    resource function delete deleteProgramme(http:Caller caller, http:Request req, string programmeCode) returns error? {
        boolean isDeleted = false;

        // Use array:filter to create a new array without the programme to be deleted
        Programme[] updatedProgrammes = programmes.filter(function(Programme p) returns boolean {
            return p.programmeCode != programmeCode;
        });

        // Check if any programme was deleted by comparing array lengths
        if (updatedProgrammes.length() != programmes.length()) {
            programmes = updatedProgrammes;
            isDeleted = true;
        }

        http:Response res = new;

        if (isDeleted) {
            res.setJsonPayload({ "message": "Programme deleted successfully." });
            res.statusCode = http:STATUS_OK;
        } else {
            res.setJsonPayload({ "message": "Programme not found." });
            res.statusCode = http:STATUS_NOT_FOUND;
        }

        check caller->respond(res);
    }
}
