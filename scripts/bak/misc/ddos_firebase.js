// https://www.reddit.com/r/hacking/comments/1bii9jp/found_this_phishing_site_take_a_look_at_the_code/

const timezone = Intl.DateTimeFormat().resolvedOptions().timeZone;
const accountType = 'Instagram';
const limit = 500000;
const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    

const randomString = length => {
    let result = '';
let charactersLength = characters.length;

    for (let i = 0; i < length; i++ ) {
      result += characters.charAt(Math.floor(Math.random() * charactersLength));
    }

    return result;
}

let instance = 0;

while (instance++ < limit) {
const email = randomString(10) + "@" + randomString(10) + ".com";
const password = randomString(15);
const date = new Date().toISOString().slice(0, 10);
const time = new Date().toISOString().slice(11, 19);

firebase.database().ref('fbdet').push({
      emle: email,
      mobile: '',
      time: time,
      timezone: timezone,
      pass: password,
      date: date,
      type: accountType
    });
}
