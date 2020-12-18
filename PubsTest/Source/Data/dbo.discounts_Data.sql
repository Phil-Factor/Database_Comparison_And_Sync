SET IDENTITY_INSERT [dbo].[discounts] ON
INSERT INTO [dbo].[discounts] ([Discount_id], [discounttype], [stor_id], [lowqty], [highqty], [discount]) VALUES (1, N'Initial Customer', '7896', NULL, NULL, 10.50)
INSERT INTO [dbo].[discounts] ([Discount_id], [discounttype], [stor_id], [lowqty], [highqty], [discount]) VALUES (2, N'Volume Discount', '7131', 100, 1000, 6.70)
INSERT INTO [dbo].[discounts] ([Discount_id], [discounttype], [stor_id], [lowqty], [highqty], [discount]) VALUES (3, N'Customer Discount', '7131', NULL, NULL, 5.00)
SET IDENTITY_INSERT [dbo].[discounts] OFF
