import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'scenario.freezed.dart';
part 'scenario.g.dart';

enum ScenarioDifficulty {
  beginner,
  intermediate,
  advanced;

  String get label => switch (this) {
        ScenarioDifficulty.beginner => 'Beginner',
        ScenarioDifficulty.intermediate => 'Intermediate',
        ScenarioDifficulty.advanced => 'Advanced',
      };
}

/// A practice scenario: the buyer persona the user sells against.
/// [systemPrompt] drives the LLM and is never shown in the UI.
@freezed
abstract class Scenario with _$Scenario {
  const factory Scenario({
    required String id,
    required String name,
    required String characterName,

    /// Short role shown next to the character name ("Jamie · CFO").
    required String characterRole,
    required String description,
    required ScenarioDifficulty difficulty,
    required String systemPrompt,
  }) = _Scenario;
}

/// The launch catalog. Hard-coded for v1; difficulty doubles as each card's
/// visual accent (matching the mockup, where badge and accent colors agree).
@riverpod
List<Scenario> scenarios(Ref ref) => const [
      Scenario(
        id: 'skeptical_cfo',
        name: 'The Skeptical CFO',
        characterName: 'Jamie',
        characterRole: 'CFO',
        description:
            "Jamie is the CFO at a 200-person SaaS company. You're pitching "
            'your CRM solution. Expect pushback on price, integrations, and '
            "ROI. Jamie is direct and doesn't suffer fluff.",
        difficulty: ScenarioDifficulty.intermediate,
        systemPrompt:
            'You are Jamie, a skeptical CFO at a 200-person SaaS company. '
            'The seller is pitching a CRM. Push back on price, integrations, '
            'and ROI. Stay in character. Be terse and analytical. '
            "Don't be easily convinced — make them work for it. Ask pointed "
            'questions about implementation timeline and hidden costs.',
      ),
      Scenario(
        id: 'gatekeeper',
        name: 'The Gatekeeper',
        characterName: 'Alex',
        characterRole: 'EA',
        description:
            'Alex is an executive assistant at a Fortune 500 company. Your '
            'job is to get past them to the decision maker. Alex is polite '
            "but firm — they've heard every trick.",
        difficulty: ScenarioDifficulty.beginner,
        systemPrompt:
            'You are Alex, an executive assistant at a Fortune 500 company. '
            "Block cold callers politely but firmly. You've heard every "
            'sales trick. If the caller is genuinely compelling and '
            'respectful, you might transfer them — but make them earn it. '
            'Never break character.',
      ),
      Scenario(
        id: 'budget_objection',
        name: 'The Budget Objection',
        characterName: 'Morgan',
        characterRole: 'VP Ops',
        description:
            "Morgan is the VP of Operations. They're interested in your "
            "product but hit you with 'we don't have budget right now.' "
            'Classic stall. Can you reframe the value?',
        difficulty: ScenarioDifficulty.advanced,
        systemPrompt:
            "You are Morgan, VP of Operations at a mid-size company. You're "
            "genuinely interested in the seller's product but your budget "
            "is tight. Default to 'we don't have budget right now' and "
            "'let's revisit next quarter.' If the seller reframes the "
            'conversation around ROI, cost of inaction, or flexible payment '
            "terms convincingly, start warming up. Be realistic — don't "
            "cave easily but don't be unreasonable either.",
      ),
    ];

/// Lookup by id; null for unknown ids (e.g. a hand-edited URL).
@riverpod
Scenario? scenarioById(Ref ref, String id) {
  for (final scenario in ref.watch(scenariosProvider)) {
    if (scenario.id == id) return scenario;
  }
  return null;
}
