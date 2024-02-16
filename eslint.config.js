// @ts-check
import eslintJS from "@eslint/js";
import eslintConfigPrettier from "eslint-config-prettier";
import * as importPlugin from "eslint-plugin-import";
import nodePlugin from "eslint-plugin-node";
import vitestPlugin from "eslint-plugin-vitest";
import globals from "globals";
import tsEslint from "typescript-eslint";

/** @type { import("eslint").Linter.FlatConfig } */
export default [
  ////////////////////////////////////////////////////////////////
  // ALL FILES
  {
    files: ["src/**/*.ts", "./*.[tj]s"],
    linterOptions: {
      reportUnusedDisableDirectives: true,
    },
    languageOptions: {
      globals: globals.node,
      ecmaVersion: "latest",
      sourceType: "module",
      parser: tsEslint.parser,
      parserOptions: {
        project: "./tsconfig.json",
        ecmaVersion: "latest",
        sourceType: "module",
        ecmaFeatures: {
          globalReturn: false,
        },
      },
    },
    plugins: {
      "@typescript-eslint": tsEslint.plugin,
      import: importPlugin,
      node: nodePlugin,
    },
    rules: {
      ...eslintJS.configs.recommended.rules,
      ...importPlugin.configs.recommended.rules,
      ...importPlugin.configs["typescript"].rules,
      ...nodePlugin.configs.recommended.rules,
      ...tsEslint.configs.eslintRecommended.rules, // turns off base eslint rules covered by ts-eslint
      ...[
        ...tsEslint.configs.strictTypeChecked,
        ...tsEslint.configs.stylisticTypeChecked, // prettier-ignore
      ].reduce((acc, { rules = {} }) => ({ ...acc, ...rules }), {}),
      "default-case": "error",
      "default-case-last": "error",
      eqeqeq: ["error", "always"],
      "prefer-const": "warn",
      semi: ["error", "always"],
      "node/no-missing-import": "off",
      "node/no-process-env": "error",
      "@typescript-eslint/no-explicit-any": "off",
      "@typescript-eslint/no-inferrable-types": "off",
      "@typescript-eslint/no-misused-promises": "error",
      ...eslintConfigPrettier.rules, // <-- must be last, removes rules that conflict with prettier
    },
    settings: {
      "import/parsers": {
        "@typescript-eslint/parser": [".ts", ".js"],
      },
      "import/resolver": {
        node: true,
        typescript: {
          project: "./tsconfig.json",
        },
      },
    },
  },
  ////////////////////////////////////////////////////////////////
  // TEST FILES
  {
    files: ["src/**/*.{test,spec}.[tj]s", "**/tests/**/*", "**/__mocks__/**/*"],
    languageOptions: {
      globals: {
        vitest: "readonly",
        vi: "readonly",
        describe: "readonly",
        it: "readonly",
        expect: "readonly",
        assert: "readonly",
        suite: "readonly",
        test: "readonly",
        beforeAll: "readonly",
        afterAll: "readonly",
        beforeEach: "readonly",
        afterEach: "readonly",
      },
    },
    plugins: {
      vitest: vitestPlugin,
    },
    rules: {
      ...vitestPlugin.configs.recommended.rules,
      "vitest/no-disabled-tests": "warn",
      "vitest/no-focused-tests": "warn",
      "vitest/valid-expect": "error",
      "@typescript-eslint/no-empty-function": "off",
      "@typescript-eslint/no-explicit-any": "off",
    },
  },
  ////////////////////////////////////////////////////////////////
];
