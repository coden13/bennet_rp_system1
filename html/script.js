window.addEventListener("message", function(event){
    if(event.data.action === "open"){
        document.getElementById("nui-container").style.display = "block";
        document.getElementById("music").play();
    }
})

function createCharacter(){
    fetch(`https://${GetParentResourceName()}/createCharacter`, {
        method:"POST",
        headers:{"Content-Type":"application/json"},
        body:JSON.stringify({
            firstname:document.getElementById("firstname").value,
            lastname:document.getElementById("lastname").value,
            age:document.getElementById("age").value,
            gender:document.getElementById("gender").value
        })
    })
}

function playMusic(){document.getElementById("music").play()}
function pauseMusic(){document.getElementById("music").pause()}
