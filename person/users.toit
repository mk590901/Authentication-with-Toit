import http
import net
import encoding.json
import certificate-roots

//  API Key
API_KEY   := "AIzaSyB9puHJBfrFuNNoFYBHXvUQFpO6kE7W4eQ"

//  Firebase Realtime Database URL
URI_AUTH  := "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$API_KEY"
URI_DB    := "https://auth-2b7d3-default-rtdb.firebaseio.com/users.json"

OK  := 200

main :

  certificate-roots.install-common-trusted-roots

  addPerson "Rudolph" " Valentino" "RudolphV@gmail.com" "(800)08-123-4567" 21
  addPerson "Linda" "Douglas" "LindaD@gmail.com" "(666)55-9876-5432" 33
  addPerson "Harrison" " Ford" "HarrisonF@gmail.com" "(333)12-3456-7890" 45

addPerson name/string surname/string email/string phone/string age/int -> none :
  token := getToken
  if token == null :
    return
  createPerson token name surname email phone age

getToken -> string? :

  // Establish network connection
  network := net.open
  client := http.Client network

  // Prepare POST request
  headers := http.Headers
  headers.set "Content-Type" "application/json"

  token/string? := null

  //  Body
  jsonObject := json.encode {"returnSecureToken": true}

  try:

    e := catch --trace=false :
    // Send POST request
      response := client.post --uri=URI_AUTH --headers=headers jsonObject
      data := json.decode-stream response.body

    // Check response
      if response.status_code == OK :
        token = data["idToken"]
      else :
        print "getToken.Error->$(response.status_code) - $data"

    if e :
      print "getToken.Exception->$e.stringify"

  finally :
    client.close
    network.close

  return token

createPerson id_token/string? name/string surname/string email/string phone/string age/int -> none :
  if not id_token :
    print "createPerson.invalidToken"
    return
  
  //  name, surname, e-mail, phone, age 
  user_data := {

    "name"    : name,
    "surname" : surname,
    "e-mail"  : email,
    "phone"   : phone,
    "age"     : age

  }

  network := net.open
  client := http.Client network

  try:

    headers := http.Headers
    headers.set "Content-Type" "application/json"
    body := json.encode user_data

    e := catch --trace=false :

      response := client.post --uri="$URI_DB?auth=$id_token" --headers=headers body
      data := json.decode-stream response.body
      
      if response.status_code == OK :
        print "createPerson.User was added->$data"
      else:
        print "createPerson.Error->$(response.status_code) - $data"

    if e :
      print "createPerson.Exception->$e.stringify"

  finally:
    client.close
    network.close
