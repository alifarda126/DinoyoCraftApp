import 'package:flutter/material.dart';
class Toko extends StatefulWidget {
	const Toko({super.key});
	@override
	TokoState createState() => TokoState();
}
class TokoState extends State<Toko> {
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
															margin: const EdgeInsets.only( bottom: 6, left: 7, right: 7),
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
																			"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/mffk0hfk_expires_30_days.png",
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
															padding: const EdgeInsets.symmetric(vertical: 5),
															width: double.infinity,
															child: Row(
																mainAxisAlignment: MainAxisAlignment.spaceBetween,
																children: [
																	IntrinsicWidth(
																		child: IntrinsicHeight(
																			child: Container(
																				margin: const EdgeInsets.only( left: 5),
																				child: Column(
																					children: [
																						IntrinsicWidth(
																							child: IntrinsicHeight(
																								child: Container(
																									padding: const EdgeInsets.only( bottom: 12),
																									child: Column(
																										crossAxisAlignment: CrossAxisAlignment.start,
																										children: [
																											Container(
																												width: 46,
																												height: 46,
																												child: Image.network(
																													"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/g0y77ohm_expires_30_days.png",
																													fit: BoxFit.fill,
																												)
																											),
																											Container(
																												margin: const EdgeInsets.only( left: 43),
																												child: Text(
																													"DinoyoCraft",
																													style: TextStyle(
																														color: Color(0xFF1A1A1A),
																														fontSize: 16,
																														fontWeight: FontWeight.bold,
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
																	),
																	IntrinsicWidth(
																		child: IntrinsicHeight(
																			child: Container(
																				margin: const EdgeInsets.only( right: 16),
																				child: Row(
																					children: [
																						Container(
																							decoration: BoxDecoration(
																								borderRadius: BorderRadius.circular(9999),
																							),
																							margin: const EdgeInsets.only( right: 8),
																							width: 36,
																							height: 36,
																							child: ClipRRect(
																								borderRadius: BorderRadius.circular(9999),
																								child: Image.network(
																									"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/pmf2qv7g_expires_30_days.png",
																									fit: BoxFit.fill,
																								)
																							)
																						),
																						Container(
																							decoration: BoxDecoration(
																								borderRadius: BorderRadius.circular(9999),
																							),
																							margin: const EdgeInsets.only( right: 8),
																							width: 36,
																							height: 36,
																							child: ClipRRect(
																								borderRadius: BorderRadius.circular(9999),
																								child: Image.network(
																									"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/00icgb3l_expires_30_days.png",
																									fit: BoxFit.fill,
																								)
																							)
																						),
																						Container(
																							decoration: BoxDecoration(
																								borderRadius: BorderRadius.circular(9999),
																							),
																							width: 40,
																							height: 40,
																							child: ClipRRect(
																								borderRadius: BorderRadius.circular(9999),
																								child: Image.network(
																									"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/ygobihlo_expires_30_days.png",
																									fit: BoxFit.fill,
																								)
																							)
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
															margin: const EdgeInsets.only( bottom: 7),
															width: double.infinity,
															child: Column(
																crossAxisAlignment: CrossAxisAlignment.start,
																children: [
																	IntrinsicHeight(
																		child: Container(
																			padding: const EdgeInsets.all(16),
																			width: double.infinity,
																			child: Column(
																				crossAxisAlignment: CrossAxisAlignment.start,
																				children: [
																					IntrinsicHeight(
																						child: Container(
																							margin: const EdgeInsets.only( bottom: 4),
																							width: double.infinity,
																							child: Column(
																								crossAxisAlignment: CrossAxisAlignment.start,
																								children: [
																									Text(
																										"Temukan Toko",
																										style: TextStyle(
																											color: Color(0xFF1A1A1A),
																											fontSize: 24,
																											fontWeight: FontWeight.bold,
																										),
																									),
																								]
																							),
																						),
																					),
																					IntrinsicHeight(
																						child: Container(
																							padding: const EdgeInsets.only( right: 41),
																							width: double.infinity,
																							child: Column(
																								crossAxisAlignment: CrossAxisAlignment.start,
																								children: [
																									Container(
																										width: double.infinity,
																										child: Text(
																											"Kenali toko dan pengrajin keramik lokal di Dinoyo.",
																											style: TextStyle(
																												color: Color(0xFF1A1A1A),
																												fontSize: 14,
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
																	IntrinsicHeight(
																		child: Container(
																			decoration: BoxDecoration(
																				border: Border.all(
																					color: Color(0xFFCCCCCC),
																					width: 1,
																				),
																				borderRadius: BorderRadius.circular(12),
																				color: Color(0xFFFFFFFF),
																			),
																			padding: const EdgeInsets.only( top: 12, bottom: 12, left: 13, right: 13),
																			margin: const EdgeInsets.symmetric(horizontal: 18),
																			width: double.infinity,
																			child: Row(
																				children: [
																					Container(
																						margin: const EdgeInsets.only( right: 11),
																						width: 16,
																						height: 16,
																						child: Image.network(
																							"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/4184s1jr_expires_30_days.png",
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
																											"Cari toko atau pengrajin...",
																											style: TextStyle(
																												color: Color(0xFFCCCCCC),
																												fontSize: 14,
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
																			padding: const EdgeInsets.symmetric(vertical: 18),
																			margin: const EdgeInsets.symmetric(horizontal: 18),
																			width: double.infinity,
																			child: Column(
																				crossAxisAlignment: CrossAxisAlignment.start,
																				children: [
																					IntrinsicHeight(
																						child: Container(
																							margin: const EdgeInsets.only( bottom: 29),
																							width: double.infinity,
																							child: Row(
																								children: [
																									Expanded(
																										child: IntrinsicHeight(
																											child: Container(
																												decoration: BoxDecoration(
																													border: Border.all(
																														color: Color(0xFFCCCCCC),
																														width: 1,
																													),
																													borderRadius: BorderRadius.circular(16),
																													color: Color(0xFFFFFFFF),
																												),
																												padding: const EdgeInsets.symmetric(vertical: 11),
																												margin: const EdgeInsets.only( right: 12),
																												width: double.infinity,
																												child: Column(
																													crossAxisAlignment: CrossAxisAlignment.start,
																													children: [
																														Container(
																															decoration: BoxDecoration(
																																borderRadius: BorderRadius.circular(12),
																															),
																															margin: const EdgeInsets.only( bottom: 4, left: 10),
																															width: 151,
																															height: 113,
																															child: ClipRRect(
																																borderRadius: BorderRadius.circular(12),
																																child: Image.network(
																																	"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/ok2c7toh_expires_30_days.png",
																																	fit: BoxFit.fill,
																																)
																															)
																														),
																														Container(
																															margin: const EdgeInsets.only( left: 10),
																															child: Text(
																																"Dinoyo Ceramic Studio",
																																style: TextStyle(
																																	color: Color(0xFF1A1A1A),
																																	fontSize: 12,
																																	fontWeight: FontWeight.bold,
																																),
																															),
																														),
																														Container(
																															margin: const EdgeInsets.only( bottom: 12, left: 11),
																															child: Text(
																																"Jl. MT  Haryono, DInoyo, Malang",
																																style: TextStyle(
																																	color: Color(0xFF1A1A1A),
																																	fontSize: 10,
																																),
																															),
																														),
																														IntrinsicWidth(
																															child: IntrinsicHeight(
																																child: Container(
																																	decoration: BoxDecoration(
																																		borderRadius: BorderRadius.circular(9999),
																																	),
																																	padding: const EdgeInsets.only( top: 2, bottom: 2, left: 8, right: 8),
																																	margin: const EdgeInsets.only( left: 6),
																																	child: Row(
																																		children: [
																																			Container(
																																				decoration: BoxDecoration(
																																					borderRadius: BorderRadius.circular(9999),
																																				),
																																				margin: const EdgeInsets.only( right: 4),
																																				width: 12,
																																				height: 12,
																																				child: ClipRRect(
																																					borderRadius: BorderRadius.circular(9999),
																																					child: Image.network(
																																						"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/nzav4vhu_expires_30_days.png",
																																						fit: BoxFit.fill,
																																					)
																																				)
																																			),
																																			Text(
																																				"4.9",
																																				style: TextStyle(
																																					color: Color(0xFF000000),
																																					fontSize: 11,
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
																									),
																									Expanded(
																										child: IntrinsicHeight(
																											child: Container(
																												decoration: BoxDecoration(
																													border: Border.all(
																														color: Color(0xFFCCCCCC),
																														width: 1,
																													),
																													borderRadius: BorderRadius.circular(16),
																													color: Color(0xFFFFFFFF),
																												),
																												padding: const EdgeInsets.symmetric(vertical: 11),
																												width: double.infinity,
																												child: Column(
																													crossAxisAlignment: CrossAxisAlignment.start,
																													children: [
																														Container(
																															decoration: BoxDecoration(
																																borderRadius: BorderRadius.circular(12),
																															),
																															margin: const EdgeInsets.only( bottom: 4, left: 10),
																															width: 151,
																															height: 113,
																															child: ClipRRect(
																																borderRadius: BorderRadius.circular(12),
																																child: Image.network(
																																	"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/efatkvfg_expires_30_days.png",
																																	fit: BoxFit.fill,
																																)
																															)
																														),
																														Container(
																															margin: const EdgeInsets.only( left: 10),
																															child: Text(
																																"Karya Tanah",
																																style: TextStyle(
																																	color: Color(0xFF1A1A1A),
																																	fontSize: 12,
																																	fontWeight: FontWeight.bold,
																																),
																															),
																														),
																														Container(
																															margin: const EdgeInsets.only( bottom: 12, left: 11),
																															child: Text(
																																"Kampung Keramik Dinoyo. M...",
																																style: TextStyle(
																																	color: Color(0xFF1A1A1A),
																																	fontSize: 10,
																																),
																															),
																														),
																														IntrinsicWidth(
																															child: IntrinsicHeight(
																																child: Container(
																																	decoration: BoxDecoration(
																																		borderRadius: BorderRadius.circular(9999),
																																	),
																																	padding: const EdgeInsets.only( top: 2, bottom: 2, left: 8, right: 8),
																																	margin: const EdgeInsets.only( left: 6),
																																	child: Row(
																																		children: [
																																			Container(
																																				decoration: BoxDecoration(
																																					borderRadius: BorderRadius.circular(9999),
																																				),
																																				margin: const EdgeInsets.only( right: 4),
																																				width: 12,
																																				height: 12,
																																				child: ClipRRect(
																																					borderRadius: BorderRadius.circular(9999),
																																					child: Image.network(
																																						"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/x3g0v2a2_expires_30_days.png",
																																						fit: BoxFit.fill,
																																					)
																																				)
																																			),
																																			Text(
																																				"4.9",
																																				style: TextStyle(
																																					color: Color(0xFF000000),
																																					fontSize: 11,
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
																									),
																								]
																							),
																						),
																					),
																					IntrinsicHeight(
																						child: Container(
																							width: double.infinity,
																							child: Row(
																								children: [
																									Expanded(
																										child: IntrinsicHeight(
																											child: Container(
																												decoration: BoxDecoration(
																													border: Border.all(
																														color: Color(0xFFCCCCCC),
																														width: 1,
																													),
																													borderRadius: BorderRadius.circular(16),
																													color: Color(0xFFFFFFFF),
																												),
																												padding: const EdgeInsets.symmetric(vertical: 11),
																												margin: const EdgeInsets.only( right: 12),
																												width: double.infinity,
																												child: Column(
																													crossAxisAlignment: CrossAxisAlignment.start,
																													children: [
																														Container(
																															decoration: BoxDecoration(
																																borderRadius: BorderRadius.circular(12),
																															),
																															margin: const EdgeInsets.only( bottom: 4, left: 10),
																															width: 151,
																															height: 113,
																															child: ClipRRect(
																																borderRadius: BorderRadius.circular(12),
																																child: Image.network(
																																	"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/esc610cd_expires_30_days.png",
																																	fit: BoxFit.fill,
																																)
																															)
																														),
																														Container(
																															margin: const EdgeInsets.only( left: 10),
																															child: Text(
																																"Ruang Tanah",
																																style: TextStyle(
																																	color: Color(0xFF1A1A1A),
																																	fontSize: 12,
																																	fontWeight: FontWeight.bold,
																																),
																															),
																														),
																														Container(
																															margin: const EdgeInsets.only( bottom: 12, left: 11),
																															child: Text(
																																"Jl. Keramik No. 12, Dinoyo",
																																style: TextStyle(
																																	color: Color(0xFF1A1A1A),
																																	fontSize: 10,
																																),
																															),
																														),
																														IntrinsicWidth(
																															child: IntrinsicHeight(
																																child: Container(
																																	decoration: BoxDecoration(
																																		borderRadius: BorderRadius.circular(9999),
																																	),
																																	padding: const EdgeInsets.only( top: 2, bottom: 2, left: 8, right: 8),
																																	margin: const EdgeInsets.only( left: 6),
																																	child: Row(
																																		children: [
																																			Container(
																																				decoration: BoxDecoration(
																																					borderRadius: BorderRadius.circular(9999),
																																				),
																																				margin: const EdgeInsets.only( right: 4),
																																				width: 12,
																																				height: 12,
																																				child: ClipRRect(
																																					borderRadius: BorderRadius.circular(9999),
																																					child: Image.network(
																																						"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/21zzbwdu_expires_30_days.png",
																																						fit: BoxFit.fill,
																																					)
																																				)
																																			),
																																			Text(
																																				"4.9",
																																				style: TextStyle(
																																					color: Color(0xFF000000),
																																					fontSize: 11,
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
																									),
																									Expanded(
																										child: IntrinsicHeight(
																											child: Container(
																												decoration: BoxDecoration(
																													border: Border.all(
																														color: Color(0xFFCCCCCC),
																														width: 1,
																													),
																													borderRadius: BorderRadius.circular(16),
																													color: Color(0xFFFFFFFF),
																												),
																												padding: const EdgeInsets.symmetric(vertical: 11),
																												width: double.infinity,
																												child: Column(
																													crossAxisAlignment: CrossAxisAlignment.start,
																													children: [
																														Container(
																															decoration: BoxDecoration(
																																borderRadius: BorderRadius.circular(12),
																															),
																															margin: const EdgeInsets.only( bottom: 4, left: 10),
																															width: 151,
																															height: 113,
																															child: ClipRRect(
																																borderRadius: BorderRadius.circular(12),
																																child: Image.network(
																																	"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/qmqg3y9c_expires_30_days.png",
																																	fit: BoxFit.fill,
																																)
																															)
																														),
																														Container(
																															margin: const EdgeInsets.only( left: 10),
																															child: Text(
																																"Dinoyo Craft House",
																																style: TextStyle(
																																	color: Color(0xFF1A1A1A),
																																	fontSize: 12,
																																	fontWeight: FontWeight.bold,
																																),
																															),
																														),
																														Container(
																															margin: const EdgeInsets.only( bottom: 12, left: 11),
																															child: Text(
																																"Jl. Simpang Gajayana, Malang",
																																style: TextStyle(
																																	color: Color(0xFF1A1A1A),
																																	fontSize: 10,
																																),
																															),
																														),
																														IntrinsicWidth(
																															child: IntrinsicHeight(
																																child: Container(
																																	decoration: BoxDecoration(
																																		borderRadius: BorderRadius.circular(9999),
																																	),
																																	padding: const EdgeInsets.only( top: 2, bottom: 2, left: 8, right: 8),
																																	margin: const EdgeInsets.only( left: 6),
																																	child: Row(
																																		children: [
																																			Container(
																																				decoration: BoxDecoration(
																																					borderRadius: BorderRadius.circular(9999),
																																				),
																																				margin: const EdgeInsets.only( right: 4),
																																				width: 12,
																																				height: 12,
																																				child: ClipRRect(
																																					borderRadius: BorderRadius.circular(9999),
																																					child: Image.network(
																																						"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/qa76dzza_expires_30_days.png",
																																						fit: BoxFit.fill,
																																					)
																																				)
																																			),
																																			Text(
																																				"4.9",
																																				style: TextStyle(
																																					color: Color(0xFF000000),
																																					fontSize: 11,
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
																									),
																								]
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
													IntrinsicHeight(
														child: Container(
															margin: const EdgeInsets.only( bottom: 12),
															width: double.infinity,
															child: Column(
																crossAxisAlignment: CrossAxisAlignment.end,
																children: [
																	Container(
																		decoration: BoxDecoration(
																			borderRadius: BorderRadius.circular(8905),
																		),
																		margin: const EdgeInsets.only( right: 20),
																		width: 57,
																		height: 57,
																		child: ClipRRect(
																			borderRadius: BorderRadius.circular(8905),
																			child: Image.network(
																				"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/y8yaccsf_expires_30_days.png",
																				fit: BoxFit.fill,
																			)
																		)
																	),
																]
															),
														),
													),
													IntrinsicHeight(
														child: Container(
															width: double.infinity,
															child: Stack(
																clipBehavior: Clip.none,
																children: [
																	Column(
																		crossAxisAlignment: CrossAxisAlignment.start,
																		children: [
																			IntrinsicHeight(
																				child: Container(
																					decoration: BoxDecoration(
																						borderRadius: BorderRadius.circular(10),
																						color: Color(0x80FFFFFF),
																					),
																					padding: const EdgeInsets.only( left: 30, right: 30),
																					width: double.infinity,
																					child: Row(
																						crossAxisAlignment: CrossAxisAlignment.start,
																						children: [
																							Expanded(
																								child: IntrinsicHeight(
																									child: Container(
																										margin: const EdgeInsets.only( top: 14, right: 29),
																										width: double.infinity,
																										child: Column(
																											children: [
																												Container(
																													width: 20,
																													height: 20,
																													child: Image.network(
																														"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/ct55007g_expires_30_days.png",
																														fit: BoxFit.fill,
																													)
																												),
																												IntrinsicHeight(
																													child: Container(
																														padding: const EdgeInsets.only( top: 4),
																														width: double.infinity,
																														child: Column(
																															crossAxisAlignment: CrossAxisAlignment.start,
																															children: [
																																Text(
																																	"Beranda",
																																	style: TextStyle(
																																		color: Color(0xFF000000),
																																		fontSize: 11,
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
																							IntrinsicWidth(
																								child: IntrinsicHeight(
																									child: Container(
																										margin: const EdgeInsets.only( top: 15, right: 48),
																										child: Column(
																											crossAxisAlignment: CrossAxisAlignment.start,
																											children: [
																												Container(
																													margin: const EdgeInsets.only( bottom: 4),
																													width: 20,
																													height: 20,
																													child: Image.network(
																														"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/e4kzvl1f_expires_30_days.png",
																														fit: BoxFit.fill,
																													)
																												),
																												Text(
																													"Produk",
																													style: TextStyle(
																														color: Color(0xFF000000),
																														fontSize: 10,
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
																										padding: const EdgeInsets.only( top: 1),
																										margin: const EdgeInsets.only( top: 40, bottom: 10, right: 36),
																										child: Column(
																											children: [
																												Text(
																													"Toko",
																													style: TextStyle(
																														color: Color(0xFF000000),
																														fontSize: 11,
																														fontWeight: FontWeight.bold,
																													),
																												),
																											]
																										),
																									),
																								),
																							),
																							Expanded(
																								child: IntrinsicHeight(
																									child: Container(
																										margin: const EdgeInsets.only( top: 15, right: 41),
																										width: double.infinity,
																										child: Column(
																											children: [
																												Container(
																													margin: const EdgeInsets.only( bottom: 4),
																													width: 20,
																													height: 20,
																													child: Image.network(
																														"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/qq82n98x_expires_30_days.png",
																														fit: BoxFit.fill,
																													)
																												),
																												Text(
																													"Workshop",
																													style: TextStyle(
																														color: Color(0xFF000000),
																														fontSize: 10,
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
																										margin: const EdgeInsets.only( top: 15),
																										child: Column(
																											crossAxisAlignment: CrossAxisAlignment.start,
																											children: [
																												Container(
																													margin: const EdgeInsets.only( bottom: 4),
																													width: 20,
																													height: 20,
																													child: Image.network(
																														"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/m0nfshe0_expires_30_days.png",
																														fit: BoxFit.fill,
																													)
																												),
																												Text(
																													"Profil",
																													style: TextStyle(
																														color: Color(0xFF000000),
																														fontSize: 10,
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
																	Positioned(
																		top: 0,
																		left: 0,
																		right: 0,
																		child: IntrinsicHeight(
																			child: Container(
																				transform: Matrix4.translationValues(0, -8, 0),
																				width: double.infinity,
																				child: Column(
																					children: [
																						InkWell(
																							onTap: () { print('Pressed'); },
																							child: IntrinsicWidth(
																								child: IntrinsicHeight(
																									child: Container(
																										decoration: BoxDecoration(
																											borderRadius: BorderRadius.circular(9999),
																											color: Color(0x00FFFFFF),
																											boxShadow: [
																												BoxShadow(
																													color: Color(0x1A000000),
																													blurRadius: 4,
																													offset: Offset(0, 2),
																												),
																											],
																										),
																										padding: const EdgeInsets.all(14),
																										child: Column(
																											crossAxisAlignment: CrossAxisAlignment.start,
																											children: [
																												Container(
																													decoration: BoxDecoration(
																														borderRadius: BorderRadius.circular(9999),
																													),
																													width: 20,
																													height: 20,
																													child: ClipRRect(
																														borderRadius: BorderRadius.circular(9999),
																														child: Image.network(
																															"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/qaxe263v_expires_30_days.png",
																															fit: BoxFit.fill,
																														)
																													)
																												),
																											]
																										),
																									),
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