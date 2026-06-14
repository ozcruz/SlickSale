import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_message.freezed.dart';

/// Who spoke a turn. [ChatRole.name] ("user" / "assistant") is exactly the
/// wire format the backend `/chat` and `/score` endpoints expect.
enum ChatRole { user, assistant }

/// One turn in the live conversation log. Distinct from the persisted
/// `TranscriptMessage` (stats feature): this carries presentation state
/// ([isStreaming]) and a [timestamp] for ordering and entrance animations.
@freezed
abstract class ChatMessage with _$ChatMessage {
  const factory ChatMessage({
    required ChatRole role,
    required String content,
    required DateTime timestamp,

    /// True while assistant text is still arriving token-by-token; drives the
    /// blinking cursor in the chat bubble.
    @Default(false) bool isStreaming,
  }) = _ChatMessage;
}
