import 'package:flutter/material.dart';
class Chat extends StatefulWidget {
	const Chat({super.key});
	@override
	ChatState createState() => ChatState();
}
class ChatState extends State<Chat> {
	@override
	Widget build(BuildContext context) {
		return Scaffold(
			body: SafeArea(
				child: Container(
					constraints: const BoxConstraints.expand(),
					color: Color(0xFFFFFFFF),
					child: Column(
						crossAxisAlignment: CrossAxisAlignment.start,
						children: [
							Expanded(
								child: IntrinsicHeight(
									child: Container(
										decoration: BoxDecoration(
											borderRadius: BorderRadius.circular(25),
											color: Color(0xFFFFFFFF),
										),
										width: double.infinity,
										height: double.infinity,
										child: SingleChildScrollView(
											padding: const EdgeInsets.only( top: 8),
											child: Column(
												crossAxisAlignment: CrossAxisAlignment.start,
												children: [
													IntrinsicHeight(
														child: Container(
															margin: const EdgeInsets.only( bottom: 4, left: 7, right: 7),
															width: double.infinity,
															child: Row(
																mainAxisAlignment: MainAxisAlignment.spaceBetween,
																children: [
																	IntrinsicWidth(
																		child: IntrinsicHeight(
																			child: Container(
																				padding: const EdgeInsets.only( top: 1, left: 35, right: 35),
																				child: Column(
																					crossAxisAlignment: CrossAxisAlignment.start,
																					children: [
																						Text(
																							"9:41",
																							style: TextStyle(
																								color: Color(0xFF000000),
																								fontSize: 17,
																							),
																						),
																					]
																				),
																			),
																		),
																	),
																	Container(
																		width: 108,
																		height: 22,
																		child: Image.network(
																			"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/7d2mr33t_expires_30_days.png",
																			fit: BoxFit.fill,
																		)
																	),
																]
															),
														),
													),
													IntrinsicHeight(
														child: Container(
															decoration: BoxDecoration(
																borderRadius: BorderRadius.only(
																	topLeft: Radius.circular(25),
																	topRight: Radius.circular(25),
																),
																color: Color(0xFFFFFFFF),
															),
															padding: const EdgeInsets.only( top: 13, bottom: 13, left: 16, right: 16),
															margin: const EdgeInsets.only( bottom: 13),
															width: double.infinity,
															child: Row(
																mainAxisAlignment: MainAxisAlignment.spaceBetween,
																children: [
																	IntrinsicWidth(
																		child: IntrinsicHeight(
																			child: Row(
																				children: [
																					Container(
																						decoration: BoxDecoration(
																							borderRadius: BorderRadius.circular(9999),
																						),
																						margin: const EdgeInsets.only( right: 8),
																						width: 21,
																						height: 25,
																						child: ClipRRect(
																							borderRadius: BorderRadius.circular(9999),
																							child: Image.network(
																								"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/rm6tqe8t_expires_30_days.png",
																								fit: BoxFit.fill,
																							)
																						)
																					),
																					Text(
																						"Pesan",
																						style: TextStyle(
																							color: Color(0xFF1A1C1C),
																							fontSize: 16,
																							fontWeight: FontWeight.bold,
																						),
																					),
																				]
																			),
																		),
																	),
																	Container(
																		width: 24,
																		height: 28,
																		child: Image.network(
																			"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/hnygyzu9_expires_30_days.png",
																			fit: BoxFit.fill,
																		)
																	),
																]
															),
														),
													),
													IntrinsicHeight(
														child: Container(
															margin: const EdgeInsets.only( bottom: 48, left: 8, right: 8),
															width: double.infinity,
															child: Column(
																crossAxisAlignment: CrossAxisAlignment.start,
																children: [
																	IntrinsicHeight(
																		child: Container(
																			decoration: BoxDecoration(
																				border: Border.all(
																					color: Color(0xFFCFC4C5),
																					width: 1,
																				),
																				borderRadius: BorderRadius.circular(16),
																				color: Color(0xFFFFFFFF),
																			),
																			padding: const EdgeInsets.all(15),
																			margin: const EdgeInsets.only( bottom: 8),
																			width: double.infinity,
																			child: Row(
																				crossAxisAlignment: CrossAxisAlignment.start,
																				children: [
																					InkWell(
																						onTap: () { print('Pressed'); },
																						child: IntrinsicWidth(
																							child: IntrinsicHeight(
																								child: Container(
																									decoration: BoxDecoration(
																										border: Border.all(
																											color: Color(0xFFCFC4C5),
																											width: 1,
																										),
																										borderRadius: BorderRadius.circular(12),
																										color: Color(0xFFEEEEEE),
																									),
																									padding: const EdgeInsets.all(1),
																									margin: const EdgeInsets.only( right: 12),
																									child: Column(
																										crossAxisAlignment: CrossAxisAlignment.start,
																										children: [
																											IntrinsicWidth(
																												child: IntrinsicHeight(
																													child: Container(
																														padding: const EdgeInsets.only( top: 32, left: 32, right: 4),
																														decoration: BoxDecoration(
																															borderRadius: BorderRadius.circular(12),
																															image: DecorationImage(
																																image: NetworkImage("https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/4vyz3tos_expires_30_days.png"),
																																fit: BoxFit.fill
																															),
																														),
																														child: Column(
																															crossAxisAlignment: CrossAxisAlignment.start,
																															children: [
																																Container(
																																	decoration: BoxDecoration(
																																		border: Border.all(
																																			color: Color(0xFFFFFFFF),
																																			width: 2,
																																		),
																																		borderRadius: BorderRadius.circular(9999),
																																		color: Color(0xFF059669),
																																	),
																																	margin: const EdgeInsets.only( bottom: 4),
																																	width: 10,
																																	height: 10,
																																	child: SizedBox(),
																																),
																															]
																														),
																													),
																												),
																											),
																										]
																									),
																								),
																							),
																						),
																					),
																					Expanded(
																						child: IntrinsicHeight(
																							child: Container(
																								width: double.infinity,
																								child: Column(
																									crossAxisAlignment: CrossAxisAlignment.start,
																									children: [
																										IntrinsicHeight(
																											child: Container(
																												margin: const EdgeInsets.only( bottom: 2),
																												width: double.infinity,
																												child: Row(
																													mainAxisAlignment: MainAxisAlignment.spaceBetween,
																													children: [
																														IntrinsicWidth(
																															child: IntrinsicHeight(
																																child: Row(
																																	children: [
																																		Container(
																																			margin: const EdgeInsets.only( right: 4),
																																			child: Text(
																																				"Dinoyo Ceramic Studio",
																																				style: TextStyle(
																																					color: Color(0xFF1A1C1C),
																																					fontSize: 14,
																																				),
																																			),
																																		),
																																		Container(
																																			width: 14,
																																			height: 14,
																																			child: Image.network(
																																				"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/ncil8lgb_expires_30_days.png",
																																				fit: BoxFit.fill,
																																			)
																																		),
																																	]
																																),
																															),
																														),
																														Container(
																															margin: const EdgeInsets.only( right: 23),
																															child: Text(
																																"14:17",
																																style: TextStyle(
																																	color: Color(0xFF5F5E5E),
																																	fontSize: 11,
																																	fontWeight: FontWeight.bold,
																																),
																															),
																														),
																													]
																												),
																											),
																										),
																										IntrinsicHeight(
																											child: Container(
																												margin: const EdgeInsets.only( bottom: 2),
																												width: double.infinity,
																												child: Row(
																													children: [
																														Container(
																															margin: const EdgeInsets.only( right: 6),
																															width: 11,
																															height: 11,
																															child: Image.network(
																																"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/ucyxj8w9_expires_30_days.png",
																																fit: BoxFit.fill,
																															)
																														),
																														Expanded(
																															child: IntrinsicHeight(
																																child: Container(
																																	width: double.infinity,
																																	child: Column(
																																		crossAxisAlignment: CrossAxisAlignment.start,
																																		children: [
																																			Text(
																																				"Ini foto kemasan standar kami kak sebelum dikirim.",
																																				style: TextStyle(
																																					color: Color(0xFF5F5E5E),
																																					fontSize: 12,
																																				),
																																			),
																																		]
																																	),
																																),
																															),
																														),
																													]
																												),
																											),
																										),
																										IntrinsicHeight(
																											child: Container(
																												padding: const EdgeInsets.symmetric(vertical: 5),
																												width: double.infinity,
																												child: Row(
																													mainAxisAlignment: MainAxisAlignment.spaceBetween,
																													children: [
																														IntrinsicWidth(
																															child: IntrinsicHeight(
																																child: Container(
																																	decoration: BoxDecoration(
																																		border: Border.all(
																																			color: Color(0xFFCFC4C5),
																																			width: 1,
																																		),
																																		borderRadius: BorderRadius.circular(6),
																																		color: Color(0xFFF4F3F3),
																																	),
																																	padding: const EdgeInsets.only( top: 3, bottom: 3, left: 9, right: 9),
																																	child: Row(
																																		children: [
																																			Container(
																																				decoration: BoxDecoration(
																																					borderRadius: BorderRadius.circular(6),
																																				),
																																				margin: const EdgeInsets.only( right: 4),
																																				width: 9,
																																				height: 11,
																																				child: ClipRRect(
																																					borderRadius: BorderRadius.circular(6),
																																					child: Image.network(
																																						"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/tfekm42d_expires_30_days.png",
																																						fit: BoxFit.fill,
																																					)
																																				)
																																			),
																																			Text(
																																				"Vas Keramik Minimalis",
																																				style: TextStyle(
																																					color: Color(0xFF4C4546),
																																					fontSize: 11,
																																					fontWeight: FontWeight.bold,
																																				),
																																			),
																																		]
																																	),
																																),
																															),
																														),
																														Container(
																															width: 14,
																															height: 8,
																															child: Image.network(
																																"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/ad3m8g0y_expires_30_days.png",
																																fit: BoxFit.fill,
																															)
																														),
																													]
																												),
																											),
																										),
																									]
																								),
																							),
																						),
																					),
																				]
																			),
																		),
																	),
																	IntrinsicHeight(
																		child: Container(
																			decoration: BoxDecoration(
																				border: Border.all(
																					color: Color(0xFF000000),
																					width: 1,
																				),
																				borderRadius: BorderRadius.circular(16),
																				color: Color(0xFFFFFFFF),
																			),
																			padding: const EdgeInsets.all(15),
																			margin: const EdgeInsets.only( bottom: 8),
																			width: double.infinity,
																			child: Row(
																				crossAxisAlignment: CrossAxisAlignment.start,
																				children: [
																					InkWell(
																						onTap: () { print('Pressed'); },
																						child: IntrinsicWidth(
																							child: IntrinsicHeight(
																								child: Container(
																									decoration: BoxDecoration(
																										border: Border.all(
																											color: Color(0xFFCFC4C5),
																											width: 1,
																										),
																										borderRadius: BorderRadius.circular(12),
																										color: Color(0xFFEEEEEE),
																									),
																									padding: const EdgeInsets.all(1),
																									margin: const EdgeInsets.only( right: 12),
																									child: Column(
																										crossAxisAlignment: CrossAxisAlignment.start,
																										children: [
																											IntrinsicWidth(
																												child: IntrinsicHeight(
																													child: Container(
																														padding: const EdgeInsets.only( top: 32, left: 32, right: 4),
																														decoration: BoxDecoration(
																															borderRadius: BorderRadius.circular(12),
																															image: DecorationImage(
																																image: NetworkImage("https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/x6t3xzlc_expires_30_days.png"),
																																fit: BoxFit.fill
																															),
																														),
																														child: Column(
																															crossAxisAlignment: CrossAxisAlignment.start,
																															children: [
																																Container(
																																	decoration: BoxDecoration(
																																		border: Border.all(
																																			color: Color(0xFFFFFFFF),
																																			width: 2,
																																		),
																																		borderRadius: BorderRadius.circular(9999),
																																		color: Color(0xFF059669),
																																	),
																																	margin: const EdgeInsets.only( bottom: 4),
																																	width: 10,
																																	height: 10,
																																	child: SizedBox(),
																																),
																															]
																														),
																													),
																												),
																											),
																										]
																									),
																								),
																							),
																						),
																					),
																					Expanded(
																						child: IntrinsicHeight(
																							child: Container(
																								width: double.infinity,
																								child: Column(
																									crossAxisAlignment: CrossAxisAlignment.start,
																									children: [
																										IntrinsicHeight(
																											child: Container(
																												margin: const EdgeInsets.only( bottom: 2),
																												width: double.infinity,
																												child: Row(
																													mainAxisAlignment: MainAxisAlignment.spaceBetween,
																													children: [
																														Text(
																															"Karya Tanah",
																															style: TextStyle(
																																color: Color(0xFF1A1C1C),
																																fontSize: 14,
																																fontWeight: FontWeight.bold,
																															),
																														),
																														Container(
																															margin: const EdgeInsets.only( right: 24),
																															child: Text(
																																"Kemarin",
																																style: TextStyle(
																																	color: Color(0xFF000000),
																																	fontSize: 11,
																																	fontWeight: FontWeight.bold,
																																),
																															),
																														),
																													]
																												),
																											),
																										),
																										IntrinsicHeight(
																											child: Container(
																												padding: const EdgeInsets.only( bottom: 6),
																												margin: const EdgeInsets.only( bottom: 2),
																												width: double.infinity,
																												child: Column(
																													crossAxisAlignment: CrossAxisAlignment.start,
																													children: [
																														Container(
																															width: double.infinity,
																															child: Text(
																																"Siap kak, untuk pesanan cangkir kopi handmade bisa kami proses hari ini.",
																																style: TextStyle(
																																	color: Color(0xFF1A1C1C),
																																	fontSize: 12,
																																),
																															),
																														),
																													]
																												),
																											),
																										),
																										IntrinsicHeight(
																											child: Container(
																												padding: const EdgeInsets.symmetric(vertical: 5),
																												width: double.infinity,
																												child: Row(
																													mainAxisAlignment: MainAxisAlignment.spaceBetween,
																													children: [
																														IntrinsicWidth(
																															child: IntrinsicHeight(
																																child: Container(
																																	decoration: BoxDecoration(
																																		border: Border.all(
																																			color: Color(0xFFCFC4C5),
																																			width: 1,
																																		),
																																		borderRadius: BorderRadius.circular(6),
																																		color: Color(0xFFF4F3F3),
																																	),
																																	padding: const EdgeInsets.only( top: 3, bottom: 3, left: 9, right: 9),
																																	child: Row(
																																		children: [
																																			Container(
																																				decoration: BoxDecoration(
																																					borderRadius: BorderRadius.circular(6),
																																				),
																																				margin: const EdgeInsets.only( right: 4),
																																				width: 9,
																																				height: 11,
																																				child: ClipRRect(
																																					borderRadius: BorderRadius.circular(6),
																																					child: Image.network(
																																						"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/yo7a7fc4_expires_30_days.png",
																																						fit: BoxFit.fill,
																																					)
																																				)
																																			),
																																			Text(
																																				"Cangkir Kopi Handmade",
																																				style: TextStyle(
																																					color: Color(0xFF4C4546),
																																					fontSize: 11,
																																					fontWeight: FontWeight.bold,
																																				),
																																			),
																																		]
																																	),
																																),
																															),
																														),
																														IntrinsicWidth(
																															child: IntrinsicHeight(
																																child: Container(
																																	decoration: BoxDecoration(
																																		borderRadius: BorderRadius.circular(9999),
																																		color: Color(0xFF000000),
																																	),
																																	padding: const EdgeInsets.only( top: 2, bottom: 2, left: 7, right: 7),
																																	child: Column(
																																		crossAxisAlignment: CrossAxisAlignment.start,
																																		children: [
																																			Text(
																																				"1",
																																				style: TextStyle(
																																					color: Color(0xFFFFFFFF),
																																					fontSize: 10,
																																					fontWeight: FontWeight.bold,
																																				),
																																			),
																																		]
																																	),
																																),
																															),
																														),
																													]
																												),
																											),
																										),
																									]
																								),
																							),
																						),
																					),
																				]
																			),
																		),
																	),
																	IntrinsicHeight(
																		child: Container(
																			decoration: BoxDecoration(
																				border: Border.all(
																					color: Color(0xFFCFC4C5),
																					width: 1,
																				),
																				borderRadius: BorderRadius.circular(16),
																				color: Color(0xFFFFFFFF),
																			),
																			padding: const EdgeInsets.all(15),
																			margin: const EdgeInsets.only( bottom: 8),
																			width: double.infinity,
																			child: Row(
																				crossAxisAlignment: CrossAxisAlignment.start,
																				children: [
																					Container(
																						decoration: BoxDecoration(
																							borderRadius: BorderRadius.circular(12),
																						),
																						margin: const EdgeInsets.only( right: 12),
																						width: 48,
																						height: 48,
																						child: ClipRRect(
																							borderRadius: BorderRadius.circular(12),
																							child: Image.network(
																								"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/cprs02pc_expires_30_days.png",
																								fit: BoxFit.fill,
																							)
																						)
																					),
																					Expanded(
																						child: IntrinsicHeight(
																							child: Container(
																								width: double.infinity,
																								child: Column(
																									crossAxisAlignment: CrossAxisAlignment.start,
																									children: [
																										IntrinsicHeight(
																											child: Container(
																												margin: const EdgeInsets.only( bottom: 2),
																												width: double.infinity,
																												child: Row(
																													mainAxisAlignment: MainAxisAlignment.spaceBetween,
																													children: [
																														Text(
																															"Ruang Tanah",
																															style: TextStyle(
																																color: Color(0xFF1A1C1C),
																																fontSize: 14,
																															),
																														),
																														Container(
																															margin: const EdgeInsets.only( right: 23),
																															child: Text(
																																"18 Feb",
																																style: TextStyle(
																																	color: Color(0xFF5F5E5E),
																																	fontSize: 11,
																																	fontWeight: FontWeight.bold,
																																),
																															),
																														),
																													]
																												),
																											),
																										),
																										IntrinsicHeight(
																											child: Container(
																												padding: const EdgeInsets.only( bottom: 6),
																												margin: const EdgeInsets.only( bottom: 2),
																												width: double.infinity,
																												child: Column(
																													crossAxisAlignment: CrossAxisAlignment.start,
																													children: [
																														Container(
																															width: double.infinity,
																															child: Text(
																																"Baik kak, silakan kirimkan alamat lengkap untuk cek ongkos kirim kayu.",
																																style: TextStyle(
																																	color: Color(0xFF5F5E5E),
																																	fontSize: 12,
																																),
																															),
																														),
																													]
																												),
																											),
																										),
																										IntrinsicHeight(
																											child: Container(
																												padding: const EdgeInsets.symmetric(vertical: 5),
																												width: double.infinity,
																												child: Row(
																													mainAxisAlignment: MainAxisAlignment.spaceBetween,
																													children: [
																														Text(
																															"Diskusi Pengiriman Khusus",
																															style: TextStyle(
																																color: Color(0xFF5F5E5E),
																																fontSize: 12,
																															),
																														),
																														Container(
																															width: 10,
																															height: 8,
																															child: Image.network(
																																"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/rmyc4md1_expires_30_days.png",
																																fit: BoxFit.fill,
																															)
																														),
																													]
																												),
																											),
																										),
																									]
																								),
																							),
																						),
																					),
																				]
																			),
																		),
																	),
																	IntrinsicHeight(
																		child: Container(
																			decoration: BoxDecoration(
																				border: Border.all(
																					color: Color(0xFFCFC4C5),
																					width: 1,
																				),
																				borderRadius: BorderRadius.circular(16),
																				color: Color(0xFFFFFFFF),
																			),
																			padding: const EdgeInsets.all(15),
																			width: double.infinity,
																			child: Row(
																				crossAxisAlignment: CrossAxisAlignment.start,
																				children: [
																					Container(
																						decoration: BoxDecoration(
																							borderRadius: BorderRadius.circular(12),
																						),
																						margin: const EdgeInsets.only( right: 12),
																						width: 48,
																						height: 48,
																						child: ClipRRect(
																							borderRadius: BorderRadius.circular(12),
																							child: Image.network(
																								"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/9zqa6e3h_expires_30_days.png",
																								fit: BoxFit.fill,
																							)
																						)
																					),
																					Expanded(
																						child: IntrinsicHeight(
																							child: Container(
																								width: double.infinity,
																								child: Column(
																									crossAxisAlignment: CrossAxisAlignment.start,
																									children: [
																										IntrinsicHeight(
																											child: Container(
																												margin: const EdgeInsets.only( bottom: 2),
																												width: double.infinity,
																												child: Row(
																													mainAxisAlignment: MainAxisAlignment.spaceBetween,
																													children: [
																														Text(
																															"Dinoyo Craft House",
																															style: TextStyle(
																																color: Color(0xFF1A1C1C),
																																fontSize: 14,
																															),
																														),
																														Container(
																															margin: const EdgeInsets.only( right: 24),
																															child: Text(
																																"14 Feb",
																																style: TextStyle(
																																	color: Color(0xFF5F5E5E),
																																	fontSize: 11,
																																	fontWeight: FontWeight.bold,
																																),
																															),
																														),
																													]
																												),
																											),
																										),
																										IntrinsicHeight(
																											child: Container(
																												padding: const EdgeInsets.only( bottom: 6),
																												margin: const EdgeInsets.only( bottom: 2),
																												width: double.infinity,
																												child: Column(
																													crossAxisAlignment: CrossAxisAlignment.start,
																													children: [
																														Container(
																															width: double.infinity,
																															child: Text(
																																"Halo, untuk paket workshop keramik akhir pekan masih ada 2 slot ya kak.",
																																style: TextStyle(
																																	color: Color(0xFF5F5E5E),
																																	fontSize: 12,
																																),
																															),
																														),
																													]
																												),
																											),
																										),
																										IntrinsicHeight(
																											child: Container(
																												padding: const EdgeInsets.symmetric(vertical: 5),
																												width: double.infinity,
																												child: Row(
																													mainAxisAlignment: MainAxisAlignment.spaceBetween,
																													children: [
																														IntrinsicWidth(
																															child: IntrinsicHeight(
																																child: Container(
																																	decoration: BoxDecoration(
																																		border: Border.all(
																																			color: Color(0xFFCFC4C5),
																																			width: 1,
																																		),
																																		borderRadius: BorderRadius.circular(6),
																																		color: Color(0xFFF4F3F3),
																																	),
																																	padding: const EdgeInsets.only( top: 3, bottom: 3, left: 9, right: 9),
																																	child: Row(
																																		children: [
																																			Container(
																																				decoration: BoxDecoration(
																																					borderRadius: BorderRadius.circular(6),
																																				),
																																				margin: const EdgeInsets.only( right: 4),
																																				width: 10,
																																				height: 10,
																																				child: ClipRRect(
																																					borderRadius: BorderRadius.circular(6),
																																					child: Image.network(
																																						"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/xuaq1iqj_expires_30_days.png",
																																						fit: BoxFit.fill,
																																					)
																																				)
																																			),
																																			Text(
																																				"Wisata Edukasi Keramik",
																																				style: TextStyle(
																																					color: Color(0xFF4C4546),
																																					fontSize: 11,
																																					fontWeight: FontWeight.bold,
																																				),
																																			),
																																		]
																																	),
																																),
																															),
																														),
																														Container(
																															width: 10,
																															height: 8,
																															child: Image.network(
																																"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/0ijb27ne_expires_30_days.png",
																																fit: BoxFit.fill,
																															)
																														),
																													]
																												),
																											),
																										),
																									]
																								),
																							),
																						),
																					),
																				]
																			),
																		),
																	),
																]
															),
														),
													),
												],
											)
										),
									),
								),
							),
						],
					),
				),
			),
		);
	}
}