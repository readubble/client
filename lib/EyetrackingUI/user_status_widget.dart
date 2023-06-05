// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:bwageul/Providers/gaze_tracker_provider.dart';
// import 'package:bwageul/Providers/user_extand_provider.dart';
//
// // UserStatusWidget 및 UserStatusExtendWidget 위젯의 구현입니다. 이들 위젯은 사용자 상태와 관련된 정보를 표시합니다.
// // UserStatusWidget은 "User Options Info"라는 텍스트와 함께 확장된 또는 축소된 사용자 상태 정보를 토글할 수 있는 버튼을 제공합니다.
// // 버튼을 클릭하면 UserStatusExtendWidget의 확장 정보가 나타나거나 사라집니다.
// // UserStatusExtendWidget에서는 GazeTrackerProvider의 상태에 따라 다양한 사용자 상태 정보를 표시합니다.
// // 사용자 주의력, 눈깜빡임 상태, 졸음 상태 등이 포함됩니다.
// class UserSatatusWidget extends StatelessWidget {
//   const UserSatatusWidget({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final extandConsumer = Provider.of<UserExtandProvider>(context);
//     const style = TextStyle(
//         color: Colors.white,
//         decoration: TextDecoration.none,
//         fontSize: 14,
//         fontWeight: FontWeight.normal);
//     return Column(children: [
//       // Directionality: 위젯의 텍스트 방향을 설정하는 위젯입니다.
//       // TextDirection.rtl을 사용하여 우측에서 좌측으로 텍스트를 표시합니다.
//       Directionality(
//         textDirection: TextDirection.rtl,
//         child: Container(
//           width: double.maxFinite,
//           color: Colors.white12,
//           child: TextButton.icon(
//             onPressed: () {
//               extandConsumer.changeIsExtand();
//             },
//             label: const Text('User Options Info', style: style),
//             // ignore: dead_code
//             icon: extandConsumer.isExtand
//                 ? const Icon(
//                     Icons.keyboard_arrow_up_sharp,
//                     color: Colors.white,
//                   )
//                 : const Icon(
//                     Icons.keyboard_arrow_down_sharp,
//                     color: Colors.white,
//                   ),
//           ),
//         ),
//       ),
//       Container(
//         height: 1,
//         color: Colors.white24,
//       ),
//       if (extandConsumer.isExtand)
//         const UserStatusExtendWidget() // UserStatusExtendWidget: 사용자 상태의 확장 정보를 표시하는 위젯입니다.
//     ]);
//   }
// }
//
// // UserStatusExtendWidget에서는 GazeTrackerProvider의 상태에 따라 다양한 사용자 상태 정보를 표시합니다.
// // 사용자 주의력, 눈깜빡임 상태, 졸음 상태 등이 포함됩니다.
// class UserStatusExtendWidget extends StatelessWidget {
//   const UserStatusExtendWidget({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final consumer = Provider.of<GazeTrackerProvider>(context);
//     const style = TextStyle(
//         color: Colors.white,
//         decoration: TextDecoration.none,
//         fontSize: 14,
//         fontWeight: FontWeight.normal);
//     return Column(
//       children: [
//         Container(
//             width: double.maxFinite,
//             height: 48,
//             color: Colors.white12,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 const Text(
//                   "User Options Info",
//                   style: style,
//                 ),
//                 Text(
//                   "${(consumer.attention * 100).toInt()}%",
//                   style: style,
//                 )
//               ],
//             )),
//         Container(
//           height: 1,
//           color: Colors.white24,
//         ),
//         Container(
//             width: double.maxFinite,
//             height: 48,
//             color: Colors.white12,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 const Text(
//                   "Blink State",
//                   style: style,
//                 ),
//                 Text(
//                   consumer.isBlink ? "Ȍ _ Ő" : "Ȕ _ Ű",
//                   style: style,
//                 )
//               ],
//             )),
//         Container(
//           height: 1,
//           color: Colors.white24,
//         ),
//         Container(
//             width: double.maxFinite,
//             height: 48,
//             color: Colors.white12,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 const Text(
//                   "Do i look seepy now..?",
//                   style: style,
//                 ),
//                 Text(
//                   consumer.isDrowsiness
//                       ? "Yes.."
//                       : "NOPE !", //Consumer: Provider 패턴을 사용하여 GazeTrackerProvider의 상태를 구독하고 사용합니다.
//                   style: style,
//                 )
//               ],
//             ))
//       ],
//     );
//   }
// }
