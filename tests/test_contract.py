import pathlib
import unittest

ROOT = pathlib.Path(__file__).resolve().parents[1]


class ContractTests(unittest.TestCase):
    def test_profiles_are_distinct(self):
        names = ["coordinateur", "marketing", "redaction", "directionartistique", "web"]
        paths = [ROOT / "agents" / name for name in names]
        self.assertEqual(len(paths), len(set(paths)))
        for path in paths:
            self.assertTrue((path / "SOUL.md").is_file())
            self.assertTrue((path / "AGENTS.md").is_file())

    def test_public_tree_has_no_private_corpus(self):
        forbidden = {"SchoolHomeSkills_Rapport_V3.odt", "SchoolHomeSkills_Business_Plan_V3.odt"}
        present = {path.name for path in ROOT.rglob("*") if path.is_file()}
        self.assertFalse(forbidden & present)

    def test_payload_publication_is_forbidden(self):
        web = (ROOT / "agents" / "web" / "AGENTS.md").read_text(encoding="utf-8")
        self.assertIn("Interdits : `PUBLISH`", web)
        self.assertIn("Relecture obligatoire", web)

    def test_wiki_example_metadata(self):
        for path in (ROOT / "wiki-example").rglob("*.md"):
            text = path.read_text(encoding="utf-8")
            for field in ("id:", "status:", "created:", "updated:", "owner:", "visibility:", "source_ids:"):
                self.assertIn(field, text, f"{field} absent dans {path}")

    def test_no_secret_like_files(self):
        bad_suffixes = {".key", ".pem", ".p12", ".pfx", ".db"}
        self.assertFalse([path for path in ROOT.rglob("*") if path.suffix.lower() in bad_suffixes])


if __name__ == "__main__":
    unittest.main()
