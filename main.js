function createTable(tx, name, row) {
    var dt = Object.keys(row);
    var res = [];
    for(var i=0; i<dt.length; ++i)
        res.push(dt[i] + " " + row[dt[i]]);
    res = "CREATE TABLE IF NOT EXISTS " + name + "(" + res.join(", ") + ");";
    tx.executeSql(res);
}

function createFirstTable() {
    return {
        "id": "INTEGER PRIMARY KEY",
         "first_name": "TEXT NOT NULL",
         "last_name": "TEXT NOT NULL",
         "email": "TEXT NOT NULL UNIQUE",
         "phone": "TEXT NOT NULL UNIQUE"
     };
}

function readNotes(tx, name, row) {
    var dt = Object.keys(row);
    var res = [];
    for(var i=0; i<dt.length; ++i)
        res.push(dt[i]);
    res = "SELECT " + res.join(", ") + " FROM " + name;
    return tx.executeSql(res);
}


function addNote(tx, name, row) {
    var dt = Object.keys(row);
    var res = [];
    var key = [];

    for(var i=0; i<dt.length; ++i) {
        key.push(dt[i]);
        res.push('"' + row[dt[i]] + '"');
    }
    res = "INSERT INTO " + name + "(" + key.join(", ") + ") VALUES(" + res.join(", ") + ");";
    return tx.executeSql(res);
}

function addIntoModel(model, data) {    
    for(var i=0; i<data.rows.length; ++i)
        model.appendRow(data.rows.item(i));
}
function editNote(tx, name, param, row, model) {
    var q = model.rows[param];
    var k = Object.keys(row);
    var res = [];
    for(var i=0; i<k.length; ++i) {
        q[k[i]] = row[k[i]];
        res.push(k[i] + " = '" + row[k[i]] + "'");
    }
    res = "UPDATE " + name + " SET " + res.join(", ") + " WHERE id = " + q.id + ";";
    console.log(res);
    model.setRow(param, q);
    tx.executeSql(res);
}




