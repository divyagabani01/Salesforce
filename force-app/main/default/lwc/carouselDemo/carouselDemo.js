import { LightningElement } from 'lwc';

export default class CarouselDemo extends LightningElement {
     carouselArr = [
        {
            id:1,
            src : Testing + '/images/smartWatch.jpg',
            header : "New Arrival: Smartwatch Pro",
            description : "Stay connected with our latest Smartwatch Pro, featuring advanced health monitoring and long battery life.",
            alternative_text : "Image showing Smartwatch Pro with sleek design.",
            href : "https://www.amazon.in/RD-Bluetooth-Smartwatch-Assistance-Pedometer/dp/B0C1P57BTB?th=1"
        },
        {
            id:2,
            src : Testing + '/images/laptop.jpg',
            header : "Summer Sale: 50% Off on Laptops",
            description : "Upgrade your tech game with our latest laptops, now available at half price during our summer sale.",
            alternative_text : "Image of a laptop with vibrant display and sleek design.",
            href : "https://www.amazon.in/Samsung-NP750XFG-KB1IN-Galaxy-Book3/dp/B0CXJ4NT4L/ref=sr_1_3?crid=2ZIKZ9CCVV0LI&dib=eyJ2IjoiMSJ9.RCQ3d1M2VLXF7hu8hIIhsY57K2pp5ijrqtOJcm4q682XT_U1cuA08JRR7u4tUUo3PqN1v_UgxWZK-WpSer5hgn2XUrR_qAGvpTY2OviUEYxYq1FDgXpwo5vBhRvolQZ1YZgfMY1fh1sQABeBJ8OGsLEFalKto6LKi1OmSRZgyGR5-b3LI5PpcJtJcO2beX0FYvsom1Z7W1ylTj79UczZAqLZk_eAsRb0DyImLSeWNEEHfic0dGffnFiZkBGyDUPvisABwLfG7_tq380Zp_wkwEmHdL2z8eMQvsAULrYC5hM.NO5Z4Sbi8_DCogTB40uKIkGwWjSEebNhtWHF_TuZw30&dib_tag=se&keywords=laptop&qid=1724415587&refinements=p_123%3A46655&rnid=91049095031&s=electronics&sprefix=lap%2Celectronics%2C180&sr=1-3&th=1"
        },
        {
            id:3,
            src : Testing + '/images/headphones.jpg',
            header : "Explore Our New Headphone Collection",
            description : "Experience premium sound quality with our latest range of wireless headphones.",
            alternative_text : "Image of wireless headphones in different colors.",
            href : "https://www.amazon.in/JBL-Wireless-Headphones-Bluetooth-Assistant/dp/B08QVBWR9X/ref=sr_1_10?crid=33N895L0955KC&dib=eyJ2IjoiMSJ9.NGlsDu5WJqaHPSZbHKX3zH0NnD6dwyc2Z7IwbSPgRH0XcnUyBrvf83xrrVUHqa--EVgttwzkAR1GEwA7Y_zbQT7KCwgl1ohcGUFAlRfcZqE06DEIChhvvmYK9_2IpM0MkcDHwilvw3R8etBXIWON_hsAAqIIgKegyyaCfGn2jms8K6YxxY6hRh6rbGt5Baeic_f-o4YBR3Xgm6WQ3E5Iri2Yc8Ugb5molRJslrgq6R3JsFqxuSdEZbxXaEu7gGiE1tIqjz69lxQ2RCxQ0W0avjyp2TILzSISwsFK9jklV38.Kb3b2-6Y2mUmYbkBEtJbSy8k2jv7zZPx6LCnAk4fZFI&dib_tag=se&keywords=headphones&qid=1724415646&s=electronics&sprefix=headphone%2Celectronics%2C182&sr=1-10&th=1"
        },
        {
            id:4,
            src : Testing + '/images/bag.jpeg',
            header : "Limited Edition: Designer Handbags",
            description : "Discover our exclusive collection of limited-edition designer handbags, crafted with elegance.",
            alternative_text : "Image of luxury handbags with intricate designs.",
            href : "https://www.amazon.in/Speed-Fashion-Womens-Tan-Handbag/dp/B09H52BLKX/ref=pd_ci_mcx_pspc_dp_d_2_i_4?pd_rd_w=qUDZH&content-id=amzn1.sym.c951cdb5-f0e8-4efb-abcb-595e3ce751f9&pf_rd_p=c951cdb5-f0e8-4efb-abcb-595e3ce751f9&pf_rd_r=JYQQE1GEKWCJRPQJBRSX&pd_rd_wg=QaxBT&pd_rd_r=cd6dbb6b-5a78-47bc-9d0b-8c1d77982dce&pd_rd_i=B07PLJXCKC&th=1"
        }
    ];
    
}