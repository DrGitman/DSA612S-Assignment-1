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

//Adding a new course and programme
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
}
