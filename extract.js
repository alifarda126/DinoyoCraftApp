const fs = require('fs');
const svgContent = fs.readFileSync('c:/dinoyocraftapp/assets/icons/Icon_lupa_password.svg', 'utf-8');
const match = svgContent.match(/xlink:href="data:image\/(?:png|jpeg);base64,([^"]+)"/);
if (match && match[1]) {
    fs.writeFileSync('c:/dinoyocraftapp/assets/images/Icon_lupa_password.jpg', Buffer.from(match[1], 'base64'));
    console.log('Successfully saved JPG.');
} else {
    console.log('Could not find base64 image data.');
}
