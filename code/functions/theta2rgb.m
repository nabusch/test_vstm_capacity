function rgb = theta2rgb(theta, a, b, radius, lightness)

%%
x = round(a + radius * sin(theta));
y = round(b + radius * cos(theta));


rgb = lab2rgb([lightness, x, y],'OutputType','uint8');
