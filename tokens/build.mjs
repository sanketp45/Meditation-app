import StyleDictionary from 'style-dictionary';

const HEADER = [
  '// GENERATED FILE — DO NOT EDIT BY HAND.',
  '// Source of truth: tokens/src/*.json',
  '// Regenerate with: npm --prefix tokens run build',
].join('\n');

function toCamelCase(segments) {
  return segments
    .map((segment, index) => {
      const parts = String(segment).split(/[-_]/).filter(Boolean);
      return parts
        .map((part, partIndex) => {
          const lower = part.toLowerCase();
          if (index === 0 && partIndex === 0) return lower;
          return lower.charAt(0).toUpperCase() + lower.slice(1);
        })
        .join('');
    })
    .join('');
}

function hexToDartColor(hex) {
  const clean = hex.replace('#', '').toUpperCase();
  const argb = clean.length === 6 ? `FF${clean}` : clean;
  return `Color(0x${argb})`;
}

const sd = new StyleDictionary({
  source: ['src/**/*.json'],
  platforms: {
    dart: {
      transformGroup: 'js',
      buildPath: '../packages/design_system/lib/generated/',
      files: [
        {
          destination: 'app_colors.dart',
          format: 'dart/colors',
          filter: (token) => token.path[0] === 'color',
        },
        {
          destination: 'app_typography.dart',
          format: 'dart/typography',
          filter: (token) => token.path[0] === 'typography' && typeof token.value === 'object',
        },
        {
          destination: 'app_spacing.dart',
          format: 'dart/spacing',
          filter: (token) => token.path[0] === 'spacing',
        },
        {
          destination: 'app_radius.dart',
          format: 'dart/radius',
          filter: (token) => token.path[0] === 'radius',
        },
      ],
    },
  },
});

await sd.registerFormat({
  name: 'dart/colors',
  format: ({ dictionary }) => {
    const fields = dictionary.allTokens
      .map((token) => {
        const name = toCamelCase(token.path.slice(1));
        return `  static const Color ${name} = ${hexToDartColor(token.value)};`;
      })
      .join('\n');
    return `${HEADER}\n\nimport 'package:flutter/painting.dart';\n\nclass AppColors {\n  AppColors._();\n\n${fields}\n}\n`;
  },
});

await sd.registerFormat({
  name: 'dart/typography',
  format: ({ dictionary }) => {
    const fields = dictionary.allTokens
      .map((token) => {
        const name = toCamelCase(token.path.slice(1));
        const { fontFamily, fontSize, lineHeight, fontWeight } = token.value;
        const height = (lineHeight / fontSize).toFixed(3);
        return `  static const TextStyle ${name} = TextStyle(\n    fontFamily: '${fontFamily}',\n    fontSize: ${fontSize},\n    height: ${height},\n    fontWeight: FontWeight.w${fontWeight},\n  );`;
      })
      .join('\n\n');
    return `${HEADER}\n\nimport 'package:flutter/painting.dart';\n\nclass AppTypography {\n  AppTypography._();\n\n${fields}\n}\n`;
  },
});

await sd.registerFormat({
  name: 'dart/spacing',
  format: ({ dictionary }) => {
    const fields = dictionary.allTokens
      .map((token) => {
        const name = toCamelCase(token.path.slice(1));
        return `  static const double ${name} = ${Number(token.value).toFixed(1)};`;
      })
      .join('\n');
    return `${HEADER}\n\nclass AppSpacing {\n  AppSpacing._();\n\n${fields}\n}\n`;
  },
});

await sd.registerFormat({
  name: 'dart/radius',
  format: ({ dictionary }) => {
    const fields = dictionary.allTokens
      .map((token) => {
        const name = toCamelCase(token.path.slice(1));
        return `  static const double ${name} = ${Number(token.value).toFixed(1)};`;
      })
      .join('\n');
    return `${HEADER}\n\nclass AppRadius {\n  AppRadius._();\n\n${fields}\n}\n`;
  },
});

await sd.hasInitialized;
await sd.cleanAllPlatforms();
await sd.buildAllPlatforms();
