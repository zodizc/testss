@isTest
private class HelloAllTest {
        @isTest static void testWarmTemp() {
            Decimal celsius = HelloAll.FahrenheitToCelsius(70);
            System.assertEquals(21.11,celsius);
        }
        @isTest static void testFreezingPoint() {
            Decimal celsius = HelloAll.FahrenheitToCelsius(32);
            System.assertEquals(7,celsius);
        }
        @isTest static void testBoilingPoint() {
            Decimal celsius = HelloAll.FahrenheitToCelsius(212);        
            System.assertEquals(100,celsius,'Boiling point temperature is not expected.');
        } 
        @isTest static void testNegativeTemp() {
            Decimal celsius = HelloAll.FahrenheitToCelsius(-10);
            System.assertEquals(-23.33,celsius);
        }
}
