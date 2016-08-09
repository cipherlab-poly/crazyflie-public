FILE(REMOVE_RECURSE
  "CMakeFiles/dynamic_reconfigure_gencfg"
  "../devel/include/dynamic_reconfigure/TestConfig.h"
  "../devel/share/dynamic_reconfigure/docs/TestConfig.dox"
  "../devel/share/dynamic_reconfigure/docs/TestConfig-usage.dox"
  "../devel/lib/python2.7/dist-packages/dynamic_reconfigure/cfg/TestConfig.py"
  "../devel/share/dynamic_reconfigure/docs/TestConfig.wikidoc"
)

# Per-language clean rules from dependency scanning.
FOREACH(lang)
  INCLUDE(CMakeFiles/dynamic_reconfigure_gencfg.dir/cmake_clean_${lang}.cmake OPTIONAL)
ENDFOREACH(lang)
