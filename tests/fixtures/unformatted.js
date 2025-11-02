// JavaScript file with issues for testing eslint
const unused_var = 42;

function badlyFormattedFunction(x,y,z){
  const result=x+y+z
  if(x==y){
    console.log("equals")
  }
  return result
}

class   BadlyFormattedClass{
  constructor(value){
    this.value=value
  }

  method(a,b){
    return a+b
  }
}

// Missing semicolons and bad formatting
const obj={a:1,b:2,c:3}
const result = badlyFormattedFunction(1,2,3)
