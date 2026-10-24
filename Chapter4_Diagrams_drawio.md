# Chapter 4 Diagrams — draw.io Source Code

This file holds the draw.io code for every diagram in **Chapter 4 (System Implementation and Documentation)** of the NaijaTax Enlighten project report. Each diagram is a complete, editable draw.io file.

## How to open a diagram in draw.io

**Option 1 – paste the code (quickest)**

1. Open https://app.diagrams.net (or the draw.io desktop app) and create a **Blank Diagram**.
2. Go to **Extras → Edit Diagram**.
3. Delete everything in the box, paste the whole code block for the diagram you want (from `<mxfile` to `</mxfile>`), and click **OK**.

**Option 2 – open as a file**

1. Copy a code block into a new text file and save it with the extension **.drawio** (for example `figure4_1.drawio`).
2. In draw.io choose **File → Open from → Device** and select the file.

**Exporting for the report:** **File → Export as → PNG**, set **Zoom 200%** and **Border width 20**, then in Word right-click the old picture → **Change Picture → From a File**. The caption under the picture stays in place.

**Editing tips:** double-click any box or arrow label to change its text. Font sizes are 13–20 pt so text stays readable when the diagram is shrunk to page width; keep them at least that size. Select an arrow and drag its yellow handles to re-route it.

## Contents

- [Figure 4.1: Three-tier system architecture of NaijaTax Enlighten](#figure-41)
- [Figure 4.2: Program modules of NaijaTax Enlighten and their linkages](#figure-42)
- [Figure 4.3: Input–process–output structure of the tax assessment module](#figure-43)
- [Figure 4.4: Context diagram (Level 0 DFD)](#figure-44)
- [Figure 4.5: Level 1 data flow diagram](#figure-45)
- [Figure 4.14: Entity relationship diagram of the database](#figure-414)

---

## Figure 4.1

**Three-tier system architecture of NaijaTax Enlighten**  
Used in section: 4.2.1 System Architecture

```xml
<mxfile host="drawio">
  <diagram id="fig4_1" name="Figure 4.1 System Architecture">
    <mxGraphModel dx="1400" dy="900" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="0" pageScale="1" math="0" shadow="0">
      <root>
        <mxCell id="0"/>
        <mxCell id="1" parent="0"/>
        <mxCell id="c3" value="NaijaTax Enlighten — Three-Tier System Architecture" style="text;html=1;align=center;verticalAlign=middle;fontSize=20;fontStyle=1;fontFamily=Helvetica;fontColor=#111111;" vertex="1" parent="1">
          <mxGeometry x="0" y="0" width="1240" height="40" as="geometry"/>
        </mxCell>
        <mxCell id="c4" value="PRESENTATION TIER  (Client — Flutter 3.44 / Dart:  Screens → Riverpod state → Dio API service)" style="rounded=0;whiteSpace=wrap;html=1;fillColor=#EEF4FF;strokeColor=#2B5797;strokeWidth=2;dashed=1;dashPattern=8 4;verticalAlign=top;align=left;spacingLeft=12;spacingTop=6;spacingBottom=6;fontSize=17;fontStyle=1;fontFamily=Helvetica;fontColor=#111111;" vertex="1" parent="1">
          <mxGeometry x="0" y="60" width="1240" height="200" as="geometry"/>
        </mxCell>
        <mxCell id="c5" value="&lt;b&gt;Android App&lt;/b&gt;&lt;br&gt;Release APK" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#DAE8FC;strokeColor=#2B5797;strokeWidth=2;fontSize=15;fontFamily=Helvetica;fontColor=#111111;arcSize=8;" vertex="1" parent="1">
          <mxGeometry x="30" y="110" width="220" height="80" as="geometry"/>
        </mxCell>
        <mxCell id="c6" value="&lt;b&gt;iOS App&lt;/b&gt;&lt;br&gt;Xcode build" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#DAE8FC;strokeColor=#2B5797;strokeWidth=2;fontSize=15;fontFamily=Helvetica;fontColor=#111111;arcSize=8;" vertex="1" parent="1">
          <mxGeometry x="280" y="110" width="220" height="80" as="geometry"/>
        </mxCell>
        <mxCell id="c7" value="&lt;b&gt;Web App&lt;/b&gt;&lt;br&gt;Hosted on Vercel" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#DAE8FC;strokeColor=#2B5797;strokeWidth=2;fontSize=15;fontFamily=Helvetica;fontColor=#111111;arcSize=8;" vertex="1" parent="1">
          <mxGeometry x="530" y="110" width="220" height="80" as="geometry"/>
        </mxCell>
        <mxCell id="c8" value="&lt;b&gt;Client services&lt;/b&gt;&lt;br&gt;Supabase Auth SDK (session)&lt;br&gt;Hive local cache (settings, last result)" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#FFF2CC;strokeColor=#B08A00;strokeWidth=2;fontSize=15;fontFamily=Helvetica;fontColor=#111111;arcSize=8;" vertex="1" parent="1">
          <mxGeometry x="820" y="110" width="380" height="100" as="geometry"/>
        </mxCell>
        <mxCell id="c9" value="MIDDLE TIER  (Business Logic — Node.js 20 + Express + TypeScript, hosted on Render)" style="rounded=0;whiteSpace=wrap;html=1;fillColor=#F1FAF0;strokeColor=#3D7A35;strokeWidth=2;dashed=1;dashPattern=8 4;verticalAlign=bottom;align=left;spacingLeft=12;spacingTop=6;spacingBottom=6;fontSize=17;fontStyle=1;fontFamily=Helvetica;fontColor=#111111;align=right;spacingRight=12;" vertex="1" parent="1">
          <mxGeometry x="0" y="320" width="1240" height="280" as="geometry"/>
        </mxCell>
        <mxCell id="c10" value="&lt;b&gt;REST API  /api/v1&lt;/b&gt;" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#D5E8D4;strokeColor=#3D7A35;strokeWidth=2;fontSize=16;fontFamily=Helvetica;fontColor=#111111;arcSize=8;" vertex="1" parent="1">
          <mxGeometry x="30" y="370" width="760" height="44" as="geometry"/>
        </mxCell>
        <mxCell id="c11" value="Prisma ORM&lt;br&gt;(data access)" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#FFFFFF;strokeColor=#3D7A35;strokeWidth=2;fontSize=14;fontFamily=Helvetica;fontColor=#111111;arcSize=8;" vertex="1" parent="1">
          <mxGeometry x="30" y="440" width="140" height="70" as="geometry"/>
        </mxCell>
        <mxCell id="c12" value="Auth middleware&lt;br&gt;(JWT via JWKS)" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#FFFFFF;strokeColor=#3D7A35;strokeWidth=2;fontSize=14;fontFamily=Helvetica;fontColor=#111111;arcSize=8;" vertex="1" parent="1">
          <mxGeometry x="185" y="440" width="140" height="70" as="geometry"/>
        </mxCell>
        <mxCell id="c13" value="Tax engine&lt;br&gt;(NTA 2025)" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#FFFFFF;strokeColor=#3D7A35;strokeWidth=2;fontSize=14;fontFamily=Helvetica;fontColor=#111111;arcSize=8;" vertex="1" parent="1">
          <mxGeometry x="340" y="440" width="140" height="70" as="geometry"/>
        </mxCell>
        <mxCell id="c14" value="AI assistant&lt;br&gt;service" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#FFFFFF;strokeColor=#3D7A35;strokeWidth=2;fontSize=14;fontFamily=Helvetica;fontColor=#111111;arcSize=8;" vertex="1" parent="1">
          <mxGeometry x="495" y="440" width="140" height="70" as="geometry"/>
        </mxCell>
        <mxCell id="c15" value="Forum, Quiz,&lt;br&gt;News, VAT" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#FFFFFF;strokeColor=#3D7A35;strokeWidth=2;fontSize=14;fontFamily=Helvetica;fontColor=#111111;arcSize=8;" vertex="1" parent="1">
          <mxGeometry x="650" y="440" width="140" height="70" as="geometry"/>
        </mxCell>
        <mxCell id="c16" value="Security: Helmet, CORS, rate limiting, input sanitising, Zod validation" style="text;html=1;align=left;verticalAlign=top;whiteSpace=wrap;fontSize=13;fontFamily=Helvetica;fontColor=#111111;" vertex="1" parent="1">
          <mxGeometry x="200" y="518" width="600" height="30" as="geometry"/>
        </mxCell>
        <mxCell id="c17" value="&lt;b&gt;Supabase Auth&lt;/b&gt;&lt;br&gt;Email, Phone OTP,&lt;br&gt;Google OAuth" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#FFE6CC;strokeColor=#B46504;strokeWidth=2;fontSize=15;fontFamily=Helvetica;fontColor=#111111;arcSize=8;" vertex="1" parent="1">
          <mxGeometry x="860" y="345" width="340" height="70" as="geometry"/>
        </mxCell>
        <mxCell id="c18" value="&lt;b&gt;AI Providers&lt;/b&gt; (prompts ⇄ answers)&lt;br&gt;Google Gemini → Groq fallback" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#FFE6CC;strokeColor=#B46504;strokeWidth=2;fontSize=15;fontFamily=Helvetica;fontColor=#111111;arcSize=8;" vertex="1" parent="1">
          <mxGeometry x="860" y="425" width="340" height="60" as="geometry"/>
        </mxCell>
        <mxCell id="c19" value="&lt;b&gt;Tax News RSS Feeds&lt;/b&gt;&lt;br&gt;FIRS, Nairametrics, BusinessDay…" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#FFE6CC;strokeColor=#B46504;strokeWidth=2;fontSize=15;fontFamily=Helvetica;fontColor=#111111;arcSize=8;" vertex="1" parent="1">
          <mxGeometry x="860" y="495" width="340" height="60" as="geometry"/>
        </mxCell>
        <mxCell id="c20" value="DATA TIER" style="rounded=0;whiteSpace=wrap;html=1;fillColor=#FFF8EE;strokeColor=#B46504;strokeWidth=2;dashed=1;dashPattern=8 4;verticalAlign=bottom;align=left;spacingLeft=12;spacingTop=6;spacingBottom=6;fontSize=17;fontStyle=1;fontFamily=Helvetica;fontColor=#111111;" vertex="1" parent="1">
          <mxGeometry x="0" y="650" width="1240" height="150" as="geometry"/>
        </mxCell>
        <mxCell id="c21" value="&lt;b&gt;PostgreSQL Database&lt;/b&gt; (Supabase)&lt;br&gt;users · tax_profiles · vat_items · chat_sessions · chat_messages · forum_topics · forum_replies · forum_votes · quiz_questions · quiz_scores · tax_articles" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#FFFFFF;strokeColor=#B46504;strokeWidth=2;fontSize=15;fontFamily=Helvetica;fontColor=#111111;arcSize=8;" vertex="1" parent="1">
          <mxGeometry x="30" y="665" width="1170" height="90" as="geometry"/>
        </mxCell>
        <mxCell id="c22" value="HTTPS / JSON&lt;br&gt;+ Bearer JWT" style="edgeStyle=orthogonalEdgeStyle;rounded=1;html=1;strokeWidth=2;strokeColor=#333333;endArrow=block;endFill=1;fontSize=13;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#111111;startArrow=block;startFill=1;exitX=0.5;exitY=1;exitDx=0;exitDy=0;entryX=0.85;entryY=0;entryDx=0;entryDy=0;" edge="1" parent="1" source="c7" target="c10">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c23" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=1;html=1;strokeWidth=2;strokeColor=#333333;endArrow=block;endFill=1;fontSize=13;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#111111;startArrow=block;startFill=1;exitX=0.5;exitY=1;exitDx=0;exitDy=0;entryX=0.15;entryY=0;entryDx=0;entryDy=0;" edge="1" parent="1" source="c5" target="c10">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c24" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=1;html=1;strokeWidth=2;strokeColor=#333333;endArrow=block;endFill=1;fontSize=13;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#111111;startArrow=block;startFill=1;exitX=0.5;exitY=1;exitDx=0;exitDy=0;entryX=0.5;entryY=0;entryDx=0;entryDy=0;" edge="1" parent="1" source="c6" target="c10">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c25" value="sign-in /&lt;br&gt;session token" style="edgeStyle=orthogonalEdgeStyle;rounded=1;html=1;strokeWidth=2;strokeColor=#333333;endArrow=block;endFill=1;fontSize=13;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#111111;startArrow=block;startFill=1;exitX=0.5;exitY=1;exitDx=0;exitDy=0;entryX=0.5;entryY=0;entryDx=0;entryDy=0;" edge="1" parent="1" source="c8" target="c17">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c26" value="SQL queries" style="edgeStyle=orthogonalEdgeStyle;rounded=1;html=1;strokeWidth=2;strokeColor=#333333;endArrow=block;endFill=1;fontSize=13;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#111111;startArrow=block;startFill=1;exitX=0.5;exitY=1;exitDx=0;exitDy=0;entryX=0.06;entryY=0;entryDx=0;entryDy=0;" edge="1" parent="1" source="c11" target="c21">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c27" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=1;html=1;strokeWidth=2;strokeColor=#333333;endArrow=block;endFill=1;fontSize=13;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#111111;startArrow=block;startFill=1;exitX=1;exitY=0.3;exitDx=0;exitDy=0;entryX=0;entryY=0.5;entryDx=0;entryDy=0;" edge="1" parent="1" source="c10" target="c18">
          <mxGeometry relative="1" as="geometry">
            <Array as="points">
              <mxPoint x="825" y="383"/>
              <mxPoint x="825" y="455"/>
            </Array>
          </mxGeometry>
        </mxCell>
        <mxCell id="c28" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=1;html=1;strokeWidth=2;strokeColor=#333333;endArrow=block;endFill=1;fontSize=13;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#111111;exitX=1;exitY=0.75;exitDx=0;exitDy=0;entryX=0;entryY=0.5;entryDx=0;entryDy=0;" edge="1" parent="1" source="c10" target="c19">
          <mxGeometry relative="1" as="geometry">
            <Array as="points">
              <mxPoint x="808" y="403"/>
              <mxPoint x="808" y="525"/>
            </Array>
          </mxGeometry>
        </mxCell>
      </root>
    </mxGraphModel>
  </diagram>
</mxfile>
```

---

## Figure 4.2

**Program modules of NaijaTax Enlighten and their linkages**  
Used in section: 4.2.3 Program Modules

```xml
<mxfile host="drawio">
  <diagram id="fig4_2" name="Figure 4.2 Program Modules">
    <mxGraphModel dx="1400" dy="900" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="0" pageScale="1" math="0" shadow="0">
      <root>
        <mxCell id="0"/>
        <mxCell id="1" parent="0"/>
        <mxCell id="c3" value="NaijaTax Enlighten — Program Modules and Linkages" style="text;html=1;align=center;verticalAlign=middle;fontSize=20;fontStyle=1;fontFamily=Helvetica;fontColor=#111111;" vertex="1" parent="1">
          <mxGeometry x="0" y="0" width="1300" height="40" as="geometry"/>
        </mxCell>
        <mxCell id="c4" value="&lt;b&gt;CONTROL CENTRE&lt;/b&gt;&lt;br&gt;App Shell · Router (go_router) · Auth state (Riverpod)" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#00288E;strokeColor=#00288E;strokeWidth=2;fontSize=16;fontFamily=Helvetica;fontColor=#111111;arcSize=8;fontColor=#FFFFFF;" vertex="1" parent="1">
          <mxGeometry x="400" y="55" width="500" height="70" as="geometry"/>
        </mxCell>
        <mxCell id="c5" value="&lt;b&gt;1. Authentication&lt;/b&gt;&lt;br&gt;• Email &amp; password&lt;br&gt;• Phone OTP&lt;br&gt;• Google sign-in&lt;br&gt;• Password reset&lt;br&gt;• Guest mode" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#DAE8FC;strokeColor=#2B5797;strokeWidth=2;fontSize=14;fontFamily=Helvetica;fontColor=#111111;arcSize=8;align=left;verticalAlign=top;spacingLeft=8;spacingTop=4;" vertex="1" parent="1">
          <mxGeometry x="0" y="175" width="240" height="125" as="geometry"/>
        </mxCell>
        <mxCell id="c6" value="&lt;b&gt;2. Onboarding&lt;/b&gt;&lt;br&gt;• Feature walkthrough&lt;br&gt;• Completion flag" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#DAE8FC;strokeColor=#2B5797;strokeWidth=2;fontSize=14;fontFamily=Helvetica;fontColor=#111111;arcSize=8;align=left;verticalAlign=top;spacingLeft=8;spacingTop=4;" vertex="1" parent="1">
          <mxGeometry x="265" y="175" width="240" height="125" as="geometry"/>
        </mxCell>
        <mxCell id="c7" value="&lt;b&gt;3. Dashboard&lt;/b&gt;&lt;br&gt;• Tax summary&lt;br&gt;• Inflation chart&lt;br&gt;• News feed&lt;br&gt;• Shortcuts" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#DAE8FC;strokeColor=#2B5797;strokeWidth=2;fontSize=14;fontFamily=Helvetica;fontColor=#111111;arcSize=8;align=left;verticalAlign=top;spacingLeft=8;spacingTop=4;" vertex="1" parent="1">
          <mxGeometry x="530" y="175" width="240" height="125" as="geometry"/>
        </mxCell>
        <mxCell id="c8" value="&lt;b&gt;4. Tax Calculator&lt;/b&gt;&lt;br&gt;• PIT (NTA 2025)&lt;br&gt;• CIT check&lt;br&gt;• Statement upload&lt;br&gt;• History &amp; PDF" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#DAE8FC;strokeColor=#2B5797;strokeWidth=2;fontSize=14;fontFamily=Helvetica;fontColor=#111111;arcSize=8;align=left;verticalAlign=top;spacingLeft=8;spacingTop=4;" vertex="1" parent="1">
          <mxGeometry x="795" y="175" width="240" height="125" as="geometry"/>
        </mxCell>
        <mxCell id="c9" value="&lt;b&gt;5. VAT Checker&lt;/b&gt;&lt;br&gt;• Item search&lt;br&gt;• Status filter" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#DAE8FC;strokeColor=#2B5797;strokeWidth=2;fontSize=14;fontFamily=Helvetica;fontColor=#111111;arcSize=8;align=left;verticalAlign=top;spacingLeft=8;spacingTop=4;" vertex="1" parent="1">
          <mxGeometry x="1060" y="175" width="240" height="125" as="geometry"/>
        </mxCell>
        <mxCell id="c10" value="&lt;b&gt;6. AI Assistant&lt;/b&gt;&lt;br&gt;• Chat sessions&lt;br&gt;• Tax Q&amp;A" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#D5E8D4;strokeColor=#3D7A35;strokeWidth=2;fontSize=14;fontFamily=Helvetica;fontColor=#111111;arcSize=8;align=left;verticalAlign=top;spacingLeft=8;spacingTop=4;" vertex="1" parent="1">
          <mxGeometry x="0" y="345" width="240" height="125" as="geometry"/>
        </mxCell>
        <mxCell id="c11" value="&lt;b&gt;7. Community Forum&lt;/b&gt;&lt;br&gt;• Topics &amp; replies&lt;br&gt;• Votes&lt;br&gt;• Accepted answer" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#D5E8D4;strokeColor=#3D7A35;strokeWidth=2;fontSize=14;fontFamily=Helvetica;fontColor=#111111;arcSize=8;align=left;verticalAlign=top;spacingLeft=8;spacingTop=4;" vertex="1" parent="1">
          <mxGeometry x="265" y="345" width="240" height="125" as="geometry"/>
        </mxCell>
        <mxCell id="c12" value="&lt;b&gt;8. Learn &amp; Quiz&lt;/b&gt;&lt;br&gt;• Tax reform guide&lt;br&gt;• Education&lt;br&gt;• Quiz &amp; scores" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#D5E8D4;strokeColor=#3D7A35;strokeWidth=2;fontSize=14;fontFamily=Helvetica;fontColor=#111111;arcSize=8;align=left;verticalAlign=top;spacingLeft=8;spacingTop=4;" vertex="1" parent="1">
          <mxGeometry x="530" y="345" width="240" height="125" as="geometry"/>
        </mxCell>
        <mxCell id="c13" value="&lt;b&gt;9. Tax News&lt;/b&gt;&lt;br&gt;• Latest articles&lt;br&gt;• Categories" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#D5E8D4;strokeColor=#3D7A35;strokeWidth=2;fontSize=14;fontFamily=Helvetica;fontColor=#111111;arcSize=8;align=left;verticalAlign=top;spacingLeft=8;spacingTop=4;" vertex="1" parent="1">
          <mxGeometry x="795" y="345" width="240" height="125" as="geometry"/>
        </mxCell>
        <mxCell id="c14" value="&lt;b&gt;10. Profile&lt;/b&gt;&lt;br&gt;• Personal details&lt;br&gt;• Avatar&lt;br&gt;• Documents vault&lt;br&gt;• Support" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#D5E8D4;strokeColor=#3D7A35;strokeWidth=2;fontSize=14;fontFamily=Helvetica;fontColor=#111111;arcSize=8;align=left;verticalAlign=top;spacingLeft=8;spacingTop=4;" vertex="1" parent="1">
          <mxGeometry x="1060" y="345" width="240" height="125" as="geometry"/>
        </mxCell>
        <mxCell id="c15" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2;strokeColor=#333333;endArrow=block;endFill=1;fontSize=13;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#111111;exitX=0.5;exitY=1;exitDx=0;exitDy=0;entryX=0.5;entryY=0;entryDx=0;entryDy=0;" edge="1" parent="1" source="c4" target="c5">
          <mxGeometry relative="1" as="geometry">
            <Array as="points">
              <mxPoint x="650" y="150"/>
              <mxPoint x="120.0" y="150"/>
            </Array>
          </mxGeometry>
        </mxCell>
        <mxCell id="c16" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2;strokeColor=#333333;endArrow=block;endFill=1;fontSize=13;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#111111;exitX=1;exitY=0.5;exitDx=0;exitDy=0;entryX=0.5;entryY=0;entryDx=0;entryDy=0;" edge="1" parent="1" source="c4" target="c10">
          <mxGeometry relative="1" as="geometry">
            <Array as="points">
              <mxPoint x="1320" y="90"/>
              <mxPoint x="1320" y="322"/>
              <mxPoint x="120.0" y="322"/>
            </Array>
          </mxGeometry>
        </mxCell>
        <mxCell id="c17" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2;strokeColor=#333333;endArrow=block;endFill=1;fontSize=13;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#111111;exitX=0.5;exitY=1;exitDx=0;exitDy=0;entryX=0.5;entryY=0;entryDx=0;entryDy=0;" edge="1" parent="1" source="c4" target="c6">
          <mxGeometry relative="1" as="geometry">
            <Array as="points">
              <mxPoint x="650" y="150"/>
              <mxPoint x="385.0" y="150"/>
            </Array>
          </mxGeometry>
        </mxCell>
        <mxCell id="c18" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2;strokeColor=#333333;endArrow=block;endFill=1;fontSize=13;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#111111;exitX=1;exitY=0.5;exitDx=0;exitDy=0;entryX=0.5;entryY=0;entryDx=0;entryDy=0;" edge="1" parent="1" source="c4" target="c11">
          <mxGeometry relative="1" as="geometry">
            <Array as="points">
              <mxPoint x="1320" y="90"/>
              <mxPoint x="1320" y="322"/>
              <mxPoint x="385.0" y="322"/>
            </Array>
          </mxGeometry>
        </mxCell>
        <mxCell id="c19" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2;strokeColor=#333333;endArrow=block;endFill=1;fontSize=13;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#111111;exitX=0.5;exitY=1;exitDx=0;exitDy=0;entryX=0.5;entryY=0;entryDx=0;entryDy=0;" edge="1" parent="1" source="c4" target="c7">
          <mxGeometry relative="1" as="geometry">
            <Array as="points">
              <mxPoint x="650" y="150"/>
              <mxPoint x="650.0" y="150"/>
            </Array>
          </mxGeometry>
        </mxCell>
        <mxCell id="c20" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2;strokeColor=#333333;endArrow=block;endFill=1;fontSize=13;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#111111;exitX=1;exitY=0.5;exitDx=0;exitDy=0;entryX=0.5;entryY=0;entryDx=0;entryDy=0;" edge="1" parent="1" source="c4" target="c12">
          <mxGeometry relative="1" as="geometry">
            <Array as="points">
              <mxPoint x="1320" y="90"/>
              <mxPoint x="1320" y="322"/>
              <mxPoint x="650.0" y="322"/>
            </Array>
          </mxGeometry>
        </mxCell>
        <mxCell id="c21" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2;strokeColor=#333333;endArrow=block;endFill=1;fontSize=13;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#111111;exitX=0.5;exitY=1;exitDx=0;exitDy=0;entryX=0.5;entryY=0;entryDx=0;entryDy=0;" edge="1" parent="1" source="c4" target="c8">
          <mxGeometry relative="1" as="geometry">
            <Array as="points">
              <mxPoint x="650" y="150"/>
              <mxPoint x="915.0" y="150"/>
            </Array>
          </mxGeometry>
        </mxCell>
        <mxCell id="c22" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2;strokeColor=#333333;endArrow=block;endFill=1;fontSize=13;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#111111;exitX=1;exitY=0.5;exitDx=0;exitDy=0;entryX=0.5;entryY=0;entryDx=0;entryDy=0;" edge="1" parent="1" source="c4" target="c13">
          <mxGeometry relative="1" as="geometry">
            <Array as="points">
              <mxPoint x="1320" y="90"/>
              <mxPoint x="1320" y="322"/>
              <mxPoint x="915.0" y="322"/>
            </Array>
          </mxGeometry>
        </mxCell>
        <mxCell id="c23" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2;strokeColor=#333333;endArrow=block;endFill=1;fontSize=13;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#111111;exitX=0.5;exitY=1;exitDx=0;exitDy=0;entryX=0.5;entryY=0;entryDx=0;entryDy=0;" edge="1" parent="1" source="c4" target="c9">
          <mxGeometry relative="1" as="geometry">
            <Array as="points">
              <mxPoint x="650" y="150"/>
              <mxPoint x="1180.0" y="150"/>
            </Array>
          </mxGeometry>
        </mxCell>
        <mxCell id="c24" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeWidth=2;strokeColor=#333333;endArrow=block;endFill=1;fontSize=13;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#111111;exitX=1;exitY=0.5;exitDx=0;exitDy=0;entryX=0.5;entryY=0;entryDx=0;entryDy=0;" edge="1" parent="1" source="c4" target="c14">
          <mxGeometry relative="1" as="geometry">
            <Array as="points">
              <mxPoint x="1320" y="90"/>
              <mxPoint x="1320" y="322"/>
              <mxPoint x="1180.0" y="322"/>
            </Array>
          </mxGeometry>
        </mxCell>
        <mxCell id="c25" value="&lt;b&gt;SERVER API MODULES&lt;/b&gt;  (Express routes → controllers → services → Prisma)" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#F5F5F5;strokeColor=#555555;strokeWidth=2;fontSize=15;fontFamily=Helvetica;fontColor=#111111;arcSize=8;" vertex="1" parent="1">
          <mxGeometry x="0" y="500" width="1300" height="36" as="geometry"/>
        </mxCell>
        <mxCell id="c26" value="&lt;b&gt;/users&lt;/b&gt;" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#FFFFFF;strokeColor=#555555;strokeWidth=2;fontSize=15;fontFamily=Helvetica;fontColor=#111111;arcSize=8;" vertex="1" parent="1">
          <mxGeometry x="20" y="550" width="190" height="44" as="geometry"/>
        </mxCell>
        <mxCell id="c27" value="&lt;b&gt;/tax&lt;/b&gt;" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#FFFFFF;strokeColor=#555555;strokeWidth=2;fontSize=15;fontFamily=Helvetica;fontColor=#111111;arcSize=8;" vertex="1" parent="1">
          <mxGeometry x="233" y="550" width="190" height="44" as="geometry"/>
        </mxCell>
        <mxCell id="c28" value="&lt;b&gt;/ai&lt;/b&gt;" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#FFFFFF;strokeColor=#555555;strokeWidth=2;fontSize=15;fontFamily=Helvetica;fontColor=#111111;arcSize=8;" vertex="1" parent="1">
          <mxGeometry x="446" y="550" width="190" height="44" as="geometry"/>
        </mxCell>
        <mxCell id="c29" value="&lt;b&gt;/forum&lt;/b&gt;" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#FFFFFF;strokeColor=#555555;strokeWidth=2;fontSize=15;fontFamily=Helvetica;fontColor=#111111;arcSize=8;" vertex="1" parent="1">
          <mxGeometry x="659" y="550" width="190" height="44" as="geometry"/>
        </mxCell>
        <mxCell id="c30" value="&lt;b&gt;/quiz&lt;/b&gt;" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#FFFFFF;strokeColor=#555555;strokeWidth=2;fontSize=15;fontFamily=Helvetica;fontColor=#111111;arcSize=8;" vertex="1" parent="1">
          <mxGeometry x="872" y="550" width="190" height="44" as="geometry"/>
        </mxCell>
        <mxCell id="c31" value="&lt;b&gt;/news&lt;/b&gt;" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#FFFFFF;strokeColor=#555555;strokeWidth=2;fontSize=15;fontFamily=Helvetica;fontColor=#111111;arcSize=8;" vertex="1" parent="1">
          <mxGeometry x="1085" y="550" width="190" height="44" as="geometry"/>
        </mxCell>
        <mxCell id="c32" value="Each client module calls its matching server module over HTTPS (e.g. Tax Calculator → /tax, AI Assistant → /ai, Profile → /users)." style="text;html=1;align=left;verticalAlign=top;whiteSpace=wrap;fontSize=13;fontFamily=Helvetica;fontColor=#111111;align=center;" vertex="1" parent="1">
          <mxGeometry x="0" y="605" width="1300" height="30" as="geometry"/>
        </mxCell>
      </root>
    </mxGraphModel>
  </diagram>
</mxfile>
```

---

## Figure 4.3

**Input–process–output structure of the tax assessment module**  
Used in section: 4.2.4 Input and Output Formats

```xml
<mxfile host="drawio">
  <diagram id="fig4_3" name="Figure 4.3 Input-Process-Output">
    <mxGraphModel dx="1400" dy="900" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="0" pageScale="1" math="0" shadow="0">
      <root>
        <mxCell id="0"/>
        <mxCell id="1" parent="0"/>
        <mxCell id="c3" value="Input – Process – Output Structure of the Tax Assessment Module" style="text;html=1;align=center;verticalAlign=middle;fontSize=20;fontStyle=1;fontFamily=Helvetica;fontColor=#111111;" vertex="1" parent="1">
          <mxGeometry x="0" y="0" width="1200" height="40" as="geometry"/>
        </mxCell>
        <mxCell id="c4" value="&lt;b&gt;INPUT&lt;/b&gt;&lt;br&gt;• Monthly (or annual) income ₦&lt;br&gt;• Annual rent paid ₦&lt;br&gt;• Pension rate (default 8%)&lt;br&gt;• Business turnover ₦ (optional)&lt;br&gt;• Business assets ₦ (optional)&lt;br&gt;• Flat rate % (percentage mode)&lt;br&gt;• Bank statement PDF (optional)" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#DAE8FC;strokeColor=#2B5797;strokeWidth=2;fontSize=15;fontFamily=Helvetica;fontColor=#111111;arcSize=8;align=left;verticalAlign=top;spacingLeft=12;spacingTop=8;" vertex="1" parent="1">
          <mxGeometry x="0" y="60" width="330" height="260" as="geometry"/>
        </mxCell>
        <mxCell id="c5" value="&lt;b&gt;PROCESS&lt;/b&gt;&lt;br&gt;• Validate input (Zod schema)&lt;br&gt;• Annualise income&lt;br&gt;• Deduct pension contribution&lt;br&gt;• Rent relief: 20% of rent, max ₦500k&lt;br&gt;• Apply NTA 2025 progressive bands&lt;br&gt;• Classify company income tax (CIT)&lt;br&gt;• Compare with old PITA regime&lt;br&gt;• Save result as Tax Profile" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#D5E8D4;strokeColor=#3D7A35;strokeWidth=2;fontSize=15;fontFamily=Helvetica;fontColor=#111111;arcSize=8;align=left;verticalAlign=top;spacingLeft=12;spacingTop=8;" vertex="1" parent="1">
          <mxGeometry x="430" y="60" width="340" height="260" as="geometry"/>
        </mxCell>
        <mxCell id="c6" value="&lt;b&gt;OUTPUT&lt;/b&gt;&lt;br&gt;• Annual gross income&lt;br&gt;• Taxable income&lt;br&gt;• Tax payable &amp; net income&lt;br&gt;• Band-by-band breakdown&lt;br&gt;• Exempt / CIT status&lt;br&gt;• Savings vs old regime&lt;br&gt;• Charts, history &amp; PDF report" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#FFE6CC;strokeColor=#B46504;strokeWidth=2;fontSize=15;fontFamily=Helvetica;fontColor=#111111;arcSize=8;align=left;verticalAlign=top;spacingLeft=12;spacingTop=8;" vertex="1" parent="1">
          <mxGeometry x="870" y="60" width="330" height="260" as="geometry"/>
        </mxCell>
        <mxCell id="c7" value="" style="html=1;strokeWidth=2;strokeColor=#333333;endArrow=block;endFill=1;fontSize=13;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#111111;" edge="1" parent="1" source="c4" target="c5">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c8" value="" style="html=1;strokeWidth=2;strokeColor=#333333;endArrow=block;endFill=1;fontSize=13;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#111111;" edge="1" parent="1" source="c5" target="c6">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c9" value="NTA 2025 bands: first ₦800k @ 0% · next ₦2.2M @ 15% · next ₦9M @ 18% · next ₦13M @ 21% · next ₦25M @ 23% · above ₦50M @ 25%" style="text;html=1;align=left;verticalAlign=top;whiteSpace=wrap;fontSize=13;fontFamily=Helvetica;fontColor=#111111;align=center;fontStyle=2;" vertex="1" parent="1">
          <mxGeometry x="0" y="335" width="1200" height="30" as="geometry"/>
        </mxCell>
      </root>
    </mxGraphModel>
  </diagram>
</mxfile>
```

---

## Figure 4.4

**Context diagram (Level 0 DFD)**  
Used in section: 4.2.6 Data Flow Diagrams

```xml
<mxfile host="drawio">
  <diagram id="fig4_4" name="Figure 4.4 Context Diagram">
    <mxGraphModel dx="1400" dy="900" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="0" pageScale="1" math="0" shadow="0">
      <root>
        <mxCell id="0"/>
        <mxCell id="1" parent="0"/>
        <mxCell id="c3" value="Context Diagram (Level 0 DFD) of NaijaTax Enlighten" style="text;html=1;align=center;verticalAlign=middle;fontSize=20;fontStyle=1;fontFamily=Helvetica;fontColor=#111111;" vertex="1" parent="1">
          <mxGeometry x="0" y="0" width="1200" height="40" as="geometry"/>
        </mxCell>
        <mxCell id="c4" value="0&lt;br&gt;NaijaTax&lt;br&gt;Enlighten&lt;br&gt;System" style="ellipse;whiteSpace=wrap;html=1;fillColor=#DAE8FC;strokeColor=#2B5797;strokeWidth=2;fontSize=14;fontStyle=1;fontFamily=Helvetica;fontColor=#111111;fontSize=18;" vertex="1" parent="1">
          <mxGeometry x="470" y="210" width="260" height="200" as="geometry"/>
        </mxCell>
        <mxCell id="c5" value="Registered User" style="rounded=0;whiteSpace=wrap;html=1;fillColor=#E1D5E7;strokeColor=#6C4A8A;strokeWidth=2;fontSize=15;fontStyle=1;fontFamily=Helvetica;fontColor=#111111;arcSize=8;" vertex="1" parent="1">
          <mxGeometry x="20" y="90" width="230" height="70" as="geometry"/>
        </mxCell>
        <mxCell id="c6" value="Guest User" style="rounded=0;whiteSpace=wrap;html=1;fillColor=#E1D5E7;strokeColor=#6C4A8A;strokeWidth=2;fontSize=15;fontStyle=1;fontFamily=Helvetica;fontColor=#111111;arcSize=8;" vertex="1" parent="1">
          <mxGeometry x="20" y="450" width="230" height="70" as="geometry"/>
        </mxCell>
        <mxCell id="c7" value="Administrator" style="rounded=0;whiteSpace=wrap;html=1;fillColor=#E1D5E7;strokeColor=#6C4A8A;strokeWidth=2;fontSize=15;fontStyle=1;fontFamily=Helvetica;fontColor=#111111;arcSize=8;" vertex="1" parent="1">
          <mxGeometry x="485" y="560" width="230" height="70" as="geometry"/>
        </mxCell>
        <mxCell id="c8" value="Supabase Auth" style="rounded=0;whiteSpace=wrap;html=1;fillColor=#E1D5E7;strokeColor=#6C4A8A;strokeWidth=2;fontSize=15;fontStyle=1;fontFamily=Helvetica;fontColor=#111111;arcSize=8;" vertex="1" parent="1">
          <mxGeometry x="950" y="90" width="230" height="70" as="geometry"/>
        </mxCell>
        <mxCell id="c9" value="AI Provider&lt;br&gt;(Gemini / Groq)" style="rounded=0;whiteSpace=wrap;html=1;fillColor=#E1D5E7;strokeColor=#6C4A8A;strokeWidth=2;fontSize=15;fontStyle=1;fontFamily=Helvetica;fontColor=#111111;arcSize=8;" vertex="1" parent="1">
          <mxGeometry x="950" y="275" width="230" height="70" as="geometry"/>
        </mxCell>
        <mxCell id="c10" value="News Sources (RSS)" style="rounded=0;whiteSpace=wrap;html=1;fillColor=#E1D5E7;strokeColor=#6C4A8A;strokeWidth=2;fontSize=15;fontStyle=1;fontFamily=Helvetica;fontColor=#111111;arcSize=8;" vertex="1" parent="1">
          <mxGeometry x="950" y="450" width="230" height="70" as="geometry"/>
        </mxCell>
        <mxCell id="c11" value="income details, questions,&lt;br&gt;forum posts, quiz answers" style="edgeStyle=orthogonalEdgeStyle;rounded=1;html=1;strokeWidth=2;strokeColor=#333333;endArrow=block;endFill=1;fontSize=13;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#111111;exitX=1;exitY=0.3;exitDx=0;exitDy=0;entryX=0.1;entryY=0.25;entryDx=0;entryDy=0;" edge="1" parent="1" source="c5" target="c4">
          <mxGeometry relative="1" as="geometry">
            <Array as="points">
              <mxPoint x="420" y="111"/>
              <mxPoint x="420" y="245"/>
            </Array>
          </mxGeometry>
        </mxCell>
        <mxCell id="c12" value="tax results, PDF report,&lt;br&gt;AI answers, scores, news" style="edgeStyle=orthogonalEdgeStyle;rounded=1;html=1;strokeWidth=2;strokeColor=#333333;endArrow=block;endFill=1;fontSize=13;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#111111;exitX=0;exitY=0.45;exitDx=0;exitDy=0;entryX=0.5;entryY=1;entryDx=0;entryDy=0;" edge="1" parent="1" source="c4" target="c5">
          <mxGeometry relative="1" as="geometry">
            <Array as="points">
              <mxPoint x="135" y="300"/>
            </Array>
          </mxGeometry>
        </mxCell>
        <mxCell id="c13" value="income details,&lt;br&gt;VAT search" style="edgeStyle=orthogonalEdgeStyle;rounded=1;html=1;strokeWidth=2;strokeColor=#333333;endArrow=block;endFill=1;fontSize=13;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#111111;exitX=1;exitY=0.3;exitDx=0;exitDy=0;entryX=0.1;entryY=0.75;entryDx=0;entryDy=0;" edge="1" parent="1" source="c6" target="c4">
          <mxGeometry relative="1" as="geometry">
            <Array as="points">
              <mxPoint x="420" y="471"/>
              <mxPoint x="420" y="360"/>
            </Array>
          </mxGeometry>
        </mxCell>
        <mxCell id="c14" value="tax estimate,&lt;br&gt;VAT status" style="edgeStyle=orthogonalEdgeStyle;rounded=1;html=1;strokeWidth=2;strokeColor=#333333;endArrow=block;endFill=1;fontSize=13;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#111111;exitX=0.25;exitY=0.95;exitDx=0;exitDy=0;entryX=1;entryY=0.75;entryDx=0;entryDy=0;" edge="1" parent="1" source="c4" target="c6">
          <mxGeometry relative="1" as="geometry">
            <Array as="points">
              <mxPoint x="535" y="503"/>
            </Array>
          </mxGeometry>
        </mxCell>
        <mxCell id="c15" value="news sync request" style="edgeStyle=orthogonalEdgeStyle;rounded=1;html=1;strokeWidth=2;strokeColor=#333333;endArrow=block;endFill=1;fontSize=13;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#111111;exitX=0.5;exitY=0;exitDx=0;exitDy=0;entryX=0.5;entryY=1;entryDx=0;entryDy=0;" edge="1" parent="1" source="c7" target="c4">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c16" value="credentials" style="edgeStyle=orthogonalEdgeStyle;rounded=1;html=1;strokeWidth=2;strokeColor=#333333;endArrow=block;endFill=1;fontSize=13;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#111111;exitX=0.85;exitY=0.15;exitDx=0;exitDy=0;entryX=0;entryY=0.3;entryDx=0;entryDy=0;" edge="1" parent="1" source="c4" target="c8">
          <mxGeometry relative="1" as="geometry">
            <Array as="points">
              <mxPoint x="700" y="111"/>
            </Array>
          </mxGeometry>
        </mxCell>
        <mxCell id="c17" value="session token (JWT)" style="edgeStyle=orthogonalEdgeStyle;rounded=1;html=1;strokeWidth=2;strokeColor=#333333;endArrow=block;endFill=1;fontSize=13;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#111111;exitX=0.5;exitY=1;exitDx=0;exitDy=0;entryX=0.95;entryY=0.35;entryDx=0;entryDy=0;" edge="1" parent="1" source="c8" target="c4">
          <mxGeometry relative="1" as="geometry">
            <Array as="points">
              <mxPoint x="1065" y="240"/>
            </Array>
          </mxGeometry>
        </mxCell>
        <mxCell id="c18" value="tax question + context" style="edgeStyle=orthogonalEdgeStyle;rounded=1;html=1;strokeWidth=2;strokeColor=#333333;endArrow=block;endFill=1;fontSize=13;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#111111;exitX=1;exitY=0.42;exitDx=0;exitDy=0;entryX=0;entryY=0.3;entryDx=0;entryDy=0;" edge="1" parent="1" source="c4" target="c9">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c19" value="generated answer" style="edgeStyle=orthogonalEdgeStyle;rounded=1;html=1;strokeWidth=2;strokeColor=#333333;endArrow=block;endFill=1;fontSize=13;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#111111;exitX=0;exitY=0.75;exitDx=0;exitDy=0;entryX=1;entryY=0.6;entryDx=0;entryDy=0;" edge="1" parent="1" source="c9" target="c4">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c20" value="tax news articles" style="edgeStyle=orthogonalEdgeStyle;rounded=1;html=1;strokeWidth=2;strokeColor=#333333;endArrow=block;endFill=1;fontSize=13;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#111111;exitX=0;exitY=0.5;exitDx=0;exitDy=0;entryX=0.9;entryY=0.8;entryDx=0;entryDy=0;" edge="1" parent="1" source="c10" target="c4">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
      </root>
    </mxGraphModel>
  </diagram>
</mxfile>
```

---

## Figure 4.5

**Level 1 data flow diagram**  
Used in section: 4.2.6 Data Flow Diagrams

```xml
<mxfile host="drawio">
  <diagram id="fig4_5" name="Figure 4.5 Level 1 DFD">
    <mxGraphModel dx="1400" dy="900" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="0" pageScale="1" math="0" shadow="0">
      <root>
        <mxCell id="0"/>
        <mxCell id="1" parent="0"/>
        <mxCell id="c3" value="Level 1 Data Flow Diagram of NaijaTax Enlighten" style="text;html=1;align=center;verticalAlign=middle;fontSize=20;fontStyle=1;fontFamily=Helvetica;fontColor=#111111;" vertex="1" parent="1">
          <mxGeometry x="-90" y="0" width="1640" height="40" as="geometry"/>
        </mxCell>
        <mxCell id="c4" value="User (Registered / Guest)" style="rounded=0;whiteSpace=wrap;html=1;fillColor=#E1D5E7;strokeColor=#6C4A8A;strokeWidth=2;fontSize=15;fontStyle=1;fontFamily=Helvetica;fontColor=#111111;arcSize=8;" vertex="1" parent="1">
          <mxGeometry x="280" y="55" width="900" height="55" as="geometry"/>
        </mxCell>
        <mxCell id="c5" value="User (Registered / Guest)" style="rounded=0;whiteSpace=wrap;html=1;fillColor=#E1D5E7;strokeColor=#6C4A8A;strokeWidth=2;fontSize=15;fontStyle=1;fontFamily=Helvetica;fontColor=#111111;arcSize=8;fillColor=#EADCF0;" vertex="1" parent="1">
          <mxGeometry x="280" y="905" width="900" height="55" as="geometry"/>
        </mxCell>
        <mxCell id="c6" value="1.0&lt;br&gt;Authenticate&lt;br&gt;User" style="ellipse;whiteSpace=wrap;html=1;fillColor=#DAE8FC;strokeColor=#2B5797;strokeWidth=2;fontSize=14;fontStyle=1;fontFamily=Helvetica;fontColor=#111111;" vertex="1" parent="1">
          <mxGeometry x="170" y="175" width="220" height="110" as="geometry"/>
        </mxCell>
        <mxCell id="c7" value="credentials" style="edgeStyle=orthogonalEdgeStyle;rounded=1;html=1;strokeWidth=2;strokeColor=#333333;endArrow=block;endFill=1;fontSize=13;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#111111;exitX=-0.05555555555555555;exitY=1;exitDx=0;exitDy=0;entryX=0.3;entryY=0;entryDx=0;entryDy=0;" edge="1" parent="1" source="c4" target="c6">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c8" value="session" style="edgeStyle=orthogonalEdgeStyle;rounded=1;html=1;strokeWidth=2;strokeColor=#333333;endArrow=block;endFill=1;fontSize=13;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#111111;exitX=0.7;exitY=0;exitDx=0;exitDy=0;entryX=0.05555555555555555;entryY=1;entryDx=0;entryDy=0;" edge="1" parent="1" source="c6" target="c4">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c9" value="D1 | Users" style="shape=partialRectangle;whiteSpace=wrap;html=1;left=1;right=0;top=1;bottom=1;fillColor=#D5E8D4;strokeColor=#3D7A35;strokeWidth=2;fontSize=14;align=left;spacingLeft=10;fontFamily=Helvetica;fontColor=#111111;" vertex="1" parent="1">
          <mxGeometry x="150" y="345" width="260" height="45" as="geometry"/>
        </mxCell>
        <mxCell id="c10" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=1;html=1;strokeWidth=2;strokeColor=#333333;endArrow=block;endFill=1;fontSize=13;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#111111;startArrow=block;startFill=1;exitX=0.5;exitY=1;exitDx=0;exitDy=0;entryX=0.5;entryY=0;entryDx=0;entryDy=0;" edge="1" parent="1" source="c6" target="c9">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c11" value="2.0&lt;br&gt;Compute&lt;br&gt;Tax" style="ellipse;whiteSpace=wrap;html=1;fillColor=#DAE8FC;strokeColor=#2B5797;strokeWidth=2;fontSize=14;fontStyle=1;fontFamily=Helvetica;fontColor=#111111;" vertex="1" parent="1">
          <mxGeometry x="470" y="175" width="220" height="110" as="geometry"/>
        </mxCell>
        <mxCell id="c12" value="income data" style="edgeStyle=orthogonalEdgeStyle;rounded=1;html=1;strokeWidth=2;strokeColor=#333333;endArrow=block;endFill=1;fontSize=13;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#111111;exitX=0.2777777777777778;exitY=1;exitDx=0;exitDy=0;entryX=0.3;entryY=0;entryDx=0;entryDy=0;" edge="1" parent="1" source="c4" target="c11">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c13" value="tax result" style="edgeStyle=orthogonalEdgeStyle;rounded=1;html=1;strokeWidth=2;strokeColor=#333333;endArrow=block;endFill=1;fontSize=13;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#111111;exitX=0.7;exitY=0;exitDx=0;exitDy=0;entryX=0.3888888888888889;entryY=1;entryDx=0;entryDy=0;" edge="1" parent="1" source="c11" target="c4">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c14" value="D2 | Tax Profiles" style="shape=partialRectangle;whiteSpace=wrap;html=1;left=1;right=0;top=1;bottom=1;fillColor=#D5E8D4;strokeColor=#3D7A35;strokeWidth=2;fontSize=14;align=left;spacingLeft=10;fontFamily=Helvetica;fontColor=#111111;" vertex="1" parent="1">
          <mxGeometry x="450" y="345" width="260" height="45" as="geometry"/>
        </mxCell>
        <mxCell id="c15" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=1;html=1;strokeWidth=2;strokeColor=#333333;endArrow=block;endFill=1;fontSize=13;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#111111;startArrow=block;startFill=1;exitX=0.5;exitY=1;exitDx=0;exitDy=0;entryX=0.5;entryY=0;entryDx=0;entryDy=0;" edge="1" parent="1" source="c11" target="c14">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c16" value="3.0&lt;br&gt;Check VAT&lt;br&gt;Status" style="ellipse;whiteSpace=wrap;html=1;fillColor=#DAE8FC;strokeColor=#2B5797;strokeWidth=2;fontSize=14;fontStyle=1;fontFamily=Helvetica;fontColor=#111111;" vertex="1" parent="1">
          <mxGeometry x="770" y="175" width="220" height="110" as="geometry"/>
        </mxCell>
        <mxCell id="c17" value="item name" style="edgeStyle=orthogonalEdgeStyle;rounded=1;html=1;strokeWidth=2;strokeColor=#333333;endArrow=block;endFill=1;fontSize=13;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#111111;exitX=0.6111111111111112;exitY=1;exitDx=0;exitDy=0;entryX=0.3;entryY=0;entryDx=0;entryDy=0;" edge="1" parent="1" source="c4" target="c16">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c18" value="VAT status" style="edgeStyle=orthogonalEdgeStyle;rounded=1;html=1;strokeWidth=2;strokeColor=#333333;endArrow=block;endFill=1;fontSize=13;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#111111;exitX=0.7;exitY=0;exitDx=0;exitDy=0;entryX=0.7222222222222222;entryY=1;entryDx=0;entryDy=0;" edge="1" parent="1" source="c16" target="c4">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c19" value="D3 | VAT Items" style="shape=partialRectangle;whiteSpace=wrap;html=1;left=1;right=0;top=1;bottom=1;fillColor=#D5E8D4;strokeColor=#3D7A35;strokeWidth=2;fontSize=14;align=left;spacingLeft=10;fontFamily=Helvetica;fontColor=#111111;" vertex="1" parent="1">
          <mxGeometry x="750" y="345" width="260" height="45" as="geometry"/>
        </mxCell>
        <mxCell id="c20" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=1;html=1;strokeWidth=2;strokeColor=#333333;endArrow=block;endFill=1;fontSize=13;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#111111;startArrow=block;startFill=1;exitX=0.5;exitY=1;exitDx=0;exitDy=0;entryX=0.5;entryY=0;entryDx=0;entryDy=0;" edge="1" parent="1" source="c16" target="c19">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c21" value="4.0&lt;br&gt;AI Tax&lt;br&gt;Assistant" style="ellipse;whiteSpace=wrap;html=1;fillColor=#DAE8FC;strokeColor=#2B5797;strokeWidth=2;fontSize=14;fontStyle=1;fontFamily=Helvetica;fontColor=#111111;" vertex="1" parent="1">
          <mxGeometry x="1070" y="175" width="220" height="110" as="geometry"/>
        </mxCell>
        <mxCell id="c22" value="question" style="edgeStyle=orthogonalEdgeStyle;rounded=1;html=1;strokeWidth=2;strokeColor=#333333;endArrow=block;endFill=1;fontSize=13;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#111111;exitX=0.9444444444444444;exitY=1;exitDx=0;exitDy=0;entryX=0.3;entryY=0;entryDx=0;entryDy=0;" edge="1" parent="1" source="c4" target="c21">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c23" value="answer" style="edgeStyle=orthogonalEdgeStyle;rounded=1;html=1;strokeWidth=2;strokeColor=#333333;endArrow=block;endFill=1;fontSize=13;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#111111;exitX=0.7;exitY=0;exitDx=0;exitDy=0;entryX=1.0555555555555556;entryY=1;entryDx=0;entryDy=0;" edge="1" parent="1" source="c21" target="c4">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c24" value="D4 | Chat Sessions &amp; Messages" style="shape=partialRectangle;whiteSpace=wrap;html=1;left=1;right=0;top=1;bottom=1;fillColor=#D5E8D4;strokeColor=#3D7A35;strokeWidth=2;fontSize=14;align=left;spacingLeft=10;fontFamily=Helvetica;fontColor=#111111;" vertex="1" parent="1">
          <mxGeometry x="1050" y="345" width="260" height="45" as="geometry"/>
        </mxCell>
        <mxCell id="c25" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=1;html=1;strokeWidth=2;strokeColor=#333333;endArrow=block;endFill=1;fontSize=13;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#111111;startArrow=block;startFill=1;exitX=0.5;exitY=1;exitDx=0;exitDy=0;entryX=0.5;entryY=0;entryDx=0;entryDy=0;" edge="1" parent="1" source="c21" target="c24">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c26" value="5.0&lt;br&gt;Manage&lt;br&gt;Forum" style="ellipse;whiteSpace=wrap;html=1;fillColor=#DAE8FC;strokeColor=#2B5797;strokeWidth=2;fontSize=14;fontStyle=1;fontFamily=Helvetica;fontColor=#111111;" vertex="1" parent="1">
          <mxGeometry x="170" y="705" width="220" height="110" as="geometry"/>
        </mxCell>
        <mxCell id="c27" value="topic / reply" style="edgeStyle=orthogonalEdgeStyle;rounded=1;html=1;strokeWidth=2;strokeColor=#333333;endArrow=block;endFill=1;fontSize=13;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#111111;exitX=-0.05555555555555555;exitY=0;exitDx=0;exitDy=0;entryX=0.3;entryY=1;entryDx=0;entryDy=0;" edge="1" parent="1" source="c5" target="c26">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c28" value="discussions" style="edgeStyle=orthogonalEdgeStyle;rounded=1;html=1;strokeWidth=2;strokeColor=#333333;endArrow=block;endFill=1;fontSize=13;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#111111;exitX=0.7;exitY=1;exitDx=0;exitDy=0;entryX=0.05555555555555555;entryY=0;entryDx=0;entryDy=0;" edge="1" parent="1" source="c26" target="c5">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c29" value="D5 | Forum Topics, Replies, Votes" style="shape=partialRectangle;whiteSpace=wrap;html=1;left=1;right=0;top=1;bottom=1;fillColor=#D5E8D4;strokeColor=#3D7A35;strokeWidth=2;fontSize=14;align=left;spacingLeft=10;fontFamily=Helvetica;fontColor=#111111;" vertex="1" parent="1">
          <mxGeometry x="150" y="580" width="260" height="45" as="geometry"/>
        </mxCell>
        <mxCell id="c30" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=1;html=1;strokeWidth=2;strokeColor=#333333;endArrow=block;endFill=1;fontSize=13;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#111111;startArrow=block;startFill=1;exitX=0.5;exitY=0;exitDx=0;exitDy=0;entryX=0.5;entryY=1;entryDx=0;entryDy=0;" edge="1" parent="1" source="c26" target="c29">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c31" value="6.0&lt;br&gt;Run&lt;br&gt;Quiz" style="ellipse;whiteSpace=wrap;html=1;fillColor=#DAE8FC;strokeColor=#2B5797;strokeWidth=2;fontSize=14;fontStyle=1;fontFamily=Helvetica;fontColor=#111111;" vertex="1" parent="1">
          <mxGeometry x="470" y="705" width="220" height="110" as="geometry"/>
        </mxCell>
        <mxCell id="c32" value="answers" style="edgeStyle=orthogonalEdgeStyle;rounded=1;html=1;strokeWidth=2;strokeColor=#333333;endArrow=block;endFill=1;fontSize=13;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#111111;exitX=0.2777777777777778;exitY=0;exitDx=0;exitDy=0;entryX=0.3;entryY=1;entryDx=0;entryDy=0;" edge="1" parent="1" source="c5" target="c31">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c33" value="score" style="edgeStyle=orthogonalEdgeStyle;rounded=1;html=1;strokeWidth=2;strokeColor=#333333;endArrow=block;endFill=1;fontSize=13;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#111111;exitX=0.7;exitY=1;exitDx=0;exitDy=0;entryX=0.3888888888888889;entryY=0;entryDx=0;entryDy=0;" edge="1" parent="1" source="c31" target="c5">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c34" value="D6 | Quiz Questions &amp; Scores" style="shape=partialRectangle;whiteSpace=wrap;html=1;left=1;right=0;top=1;bottom=1;fillColor=#D5E8D4;strokeColor=#3D7A35;strokeWidth=2;fontSize=14;align=left;spacingLeft=10;fontFamily=Helvetica;fontColor=#111111;" vertex="1" parent="1">
          <mxGeometry x="450" y="580" width="260" height="45" as="geometry"/>
        </mxCell>
        <mxCell id="c35" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=1;html=1;strokeWidth=2;strokeColor=#333333;endArrow=block;endFill=1;fontSize=13;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#111111;startArrow=block;startFill=1;exitX=0.5;exitY=0;exitDx=0;exitDy=0;entryX=0.5;entryY=1;entryDx=0;entryDy=0;" edge="1" parent="1" source="c31" target="c34">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c36" value="7.0&lt;br&gt;Manage&lt;br&gt;Profile" style="ellipse;whiteSpace=wrap;html=1;fillColor=#DAE8FC;strokeColor=#2B5797;strokeWidth=2;fontSize=14;fontStyle=1;fontFamily=Helvetica;fontColor=#111111;" vertex="1" parent="1">
          <mxGeometry x="770" y="705" width="220" height="110" as="geometry"/>
        </mxCell>
        <mxCell id="c37" value="profile edits" style="edgeStyle=orthogonalEdgeStyle;rounded=1;html=1;strokeWidth=2;strokeColor=#333333;endArrow=block;endFill=1;fontSize=13;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#111111;exitX=0.6111111111111112;exitY=0;exitDx=0;exitDy=0;entryX=0.3;entryY=1;entryDx=0;entryDy=0;" edge="1" parent="1" source="c5" target="c36">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c38" value="profile" style="edgeStyle=orthogonalEdgeStyle;rounded=1;html=1;strokeWidth=2;strokeColor=#333333;endArrow=block;endFill=1;fontSize=13;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#111111;exitX=0.7;exitY=1;exitDx=0;exitDy=0;entryX=0.7222222222222222;entryY=0;entryDx=0;entryDy=0;" edge="1" parent="1" source="c36" target="c5">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c39" value="D1 | Users" style="shape=partialRectangle;whiteSpace=wrap;html=1;left=1;right=0;top=1;bottom=1;fillColor=#D5E8D4;strokeColor=#3D7A35;strokeWidth=2;fontSize=14;align=left;spacingLeft=10;fontFamily=Helvetica;fontColor=#111111;" vertex="1" parent="1">
          <mxGeometry x="750" y="580" width="260" height="45" as="geometry"/>
        </mxCell>
        <mxCell id="c40" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=1;html=1;strokeWidth=2;strokeColor=#333333;endArrow=block;endFill=1;fontSize=13;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#111111;startArrow=block;startFill=1;exitX=0.5;exitY=0;exitDx=0;exitDy=0;entryX=0.5;entryY=1;entryDx=0;entryDy=0;" edge="1" parent="1" source="c36" target="c39">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c41" value="8.0&lt;br&gt;Sync &amp; Serve&lt;br&gt;News" style="ellipse;whiteSpace=wrap;html=1;fillColor=#DAE8FC;strokeColor=#2B5797;strokeWidth=2;fontSize=14;fontStyle=1;fontFamily=Helvetica;fontColor=#111111;" vertex="1" parent="1">
          <mxGeometry x="1070" y="705" width="220" height="110" as="geometry"/>
        </mxCell>
        <mxCell id="c42" value="news" style="edgeStyle=orthogonalEdgeStyle;rounded=1;html=1;strokeWidth=2;strokeColor=#333333;endArrow=block;endFill=1;fontSize=13;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#111111;exitX=0.7;exitY=1;exitDx=0;exitDy=0;entryX=1.0555555555555556;entryY=0;entryDx=0;entryDy=0;" edge="1" parent="1" source="c41" target="c5">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c43" value="D7 | Tax Articles" style="shape=partialRectangle;whiteSpace=wrap;html=1;left=1;right=0;top=1;bottom=1;fillColor=#D5E8D4;strokeColor=#3D7A35;strokeWidth=2;fontSize=14;align=left;spacingLeft=10;fontFamily=Helvetica;fontColor=#111111;" vertex="1" parent="1">
          <mxGeometry x="1050" y="580" width="260" height="45" as="geometry"/>
        </mxCell>
        <mxCell id="c44" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=1;html=1;strokeWidth=2;strokeColor=#333333;endArrow=block;endFill=1;fontSize=13;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#111111;startArrow=block;startFill=1;exitX=0.5;exitY=0;exitDx=0;exitDy=0;entryX=0.5;entryY=1;entryDx=0;entryDy=0;" edge="1" parent="1" source="c41" target="c43">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c45" value="Supabase&lt;br&gt;Auth" style="rounded=0;whiteSpace=wrap;html=1;fillColor=#E1D5E7;strokeColor=#6C4A8A;strokeWidth=2;fontSize=15;fontStyle=1;fontFamily=Helvetica;fontColor=#111111;arcSize=8;" vertex="1" parent="1">
          <mxGeometry x="-90" y="190" width="150" height="80" as="geometry"/>
        </mxCell>
        <mxCell id="c46" value="login" style="edgeStyle=orthogonalEdgeStyle;rounded=1;html=1;strokeWidth=2;strokeColor=#333333;endArrow=block;endFill=1;fontSize=13;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#111111;startArrow=block;startFill=1;exitX=0;exitY=0.5;exitDx=0;exitDy=0;entryX=1;entryY=0.5;entryDx=0;entryDy=0;" edge="1" parent="1" source="c6" target="c45">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c47" value="AI Provider" style="rounded=0;whiteSpace=wrap;html=1;fillColor=#E1D5E7;strokeColor=#6C4A8A;strokeWidth=2;fontSize=15;fontStyle=1;fontFamily=Helvetica;fontColor=#111111;arcSize=8;" vertex="1" parent="1">
          <mxGeometry x="1400" y="190" width="150" height="80" as="geometry"/>
        </mxCell>
        <mxCell id="c48" value="question /&lt;br&gt;answer" style="edgeStyle=orthogonalEdgeStyle;rounded=1;html=1;strokeWidth=2;strokeColor=#333333;endArrow=block;endFill=1;fontSize=13;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#111111;startArrow=block;startFill=1;exitX=1;exitY=0.5;exitDx=0;exitDy=0;entryX=0;entryY=0.5;entryDx=0;entryDy=0;" edge="1" parent="1" source="c21" target="c47">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c49" value="News&lt;br&gt;Sources" style="rounded=0;whiteSpace=wrap;html=1;fillColor=#E1D5E7;strokeColor=#6C4A8A;strokeWidth=2;fontSize=15;fontStyle=1;fontFamily=Helvetica;fontColor=#111111;arcSize=8;" vertex="1" parent="1">
          <mxGeometry x="1400" y="680" width="150" height="70" as="geometry"/>
        </mxCell>
        <mxCell id="c50" value="articles" style="edgeStyle=orthogonalEdgeStyle;rounded=1;html=1;strokeWidth=2;strokeColor=#333333;endArrow=block;endFill=1;fontSize=13;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#111111;exitX=0;exitY=0.5;exitDx=0;exitDy=0;entryX=1;entryY=0.4;entryDx=0;entryDy=0;" edge="1" parent="1" source="c49" target="c41">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c51" value="Admin" style="rounded=0;whiteSpace=wrap;html=1;fillColor=#E1D5E7;strokeColor=#6C4A8A;strokeWidth=2;fontSize=15;fontStyle=1;fontFamily=Helvetica;fontColor=#111111;arcSize=8;" vertex="1" parent="1">
          <mxGeometry x="1400" y="790" width="150" height="55" as="geometry"/>
        </mxCell>
        <mxCell id="c52" value="sync" style="edgeStyle=orthogonalEdgeStyle;rounded=1;html=1;strokeWidth=2;strokeColor=#333333;endArrow=block;endFill=1;fontSize=13;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#111111;exitX=0;exitY=0.5;exitDx=0;exitDy=0;entryX=1;entryY=0.75;entryDx=0;entryDy=0;" edge="1" parent="1" source="c51" target="c41">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c53" value="&lt;b&gt;Legend (DFD symbols)&lt;/b&gt;" style="text;html=1;align=left;verticalAlign=top;whiteSpace=wrap;fontSize=13;fontFamily=Helvetica;fontColor=#111111;" vertex="1" parent="1">
          <mxGeometry x="0" y="440" width="300" height="28" as="geometry"/>
        </mxCell>
        <mxCell id="c54" value="External entity" style="rounded=0;whiteSpace=wrap;html=1;fillColor=#E1D5E7;strokeColor=#6C4A8A;strokeWidth=2;fontSize=15;fontStyle=1;fontFamily=Helvetica;fontColor=#111111;arcSize=8;fontSize=12;" vertex="1" parent="1">
          <mxGeometry x="0" y="472" width="140" height="40" as="geometry"/>
        </mxCell>
        <mxCell id="c55" value="Process" style="ellipse;whiteSpace=wrap;html=1;fillColor=#DAE8FC;strokeColor=#2B5797;strokeWidth=2;fontSize=14;fontStyle=1;fontFamily=Helvetica;fontColor=#111111;fontSize=12;" vertex="1" parent="1">
          <mxGeometry x="160" y="466" width="130" height="52" as="geometry"/>
        </mxCell>
        <mxCell id="c56" value="Dn | Data store" style="shape=partialRectangle;whiteSpace=wrap;html=1;left=1;right=0;top=1;bottom=1;fillColor=#D5E8D4;strokeColor=#3D7A35;strokeWidth=2;fontSize=14;align=left;spacingLeft=10;fontFamily=Helvetica;fontColor=#111111;fontSize=12;" vertex="1" parent="1">
          <mxGeometry x="320" y="472" width="150" height="40" as="geometry"/>
        </mxCell>
        <mxCell id="c57" value="" style="text;html=1;" vertex="1" parent="1">
          <mxGeometry x="500" y="492" width="1" height="1" as="geometry"/>
        </mxCell>
        <mxCell id="c58" value="Data flow" style="text;html=1;align=left;verticalAlign=top;whiteSpace=wrap;fontSize=13;fontFamily=Helvetica;fontColor=#111111;verticalAlign=middle;" vertex="1" parent="1">
          <mxGeometry x="600" y="477" width="120" height="30" as="geometry"/>
        </mxCell>
        <mxCell id="c59" value="" style="html=1;strokeWidth=2;strokeColor=#333333;endArrow=block;endFill=1;fontSize=13;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#111111;" edge="1" parent="1" source="c57" target="c58">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
      </root>
    </mxGraphModel>
  </diagram>
</mxfile>
```

---

## Figure 4.14

**Entity relationship diagram of the database**  
Used in section: 4.4 Documentation – Data Dictionary

```xml
<mxfile host="drawio">
  <diagram id="fig4_6" name="Figure 4.6 Entity Relationship Diagram">
    <mxGraphModel dx="1400" dy="900" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="0" pageScale="1" math="0" shadow="0">
      <root>
        <mxCell id="0"/>
        <mxCell id="1" parent="0"/>
        <mxCell id="c3" value="Entity Relationship Diagram (PostgreSQL schema via Prisma)" style="text;html=1;align=center;verticalAlign=middle;fontSize=20;fontStyle=1;fontFamily=Helvetica;fontColor=#111111;" vertex="1" parent="1">
          <mxGeometry x="0" y="0" width="1320" height="40" as="geometry"/>
        </mxCell>
        <mxCell id="c4" value="users" style="swimlane;fontStyle=1;childLayout=stackLayout;horizontal=1;startSize=30;horizontalStack=0;resizeParent=1;resizeParentMax=0;resizeLast=0;collapsible=0;html=1;fillColor=#FFF2CC;strokeColor=#B08A00;strokeWidth=2;fontSize=15;fontFamily=Helvetica;fontColor=#111111;" vertex="1" parent="1">
          <mxGeometry x="540" y="60" width="250" height="240" as="geometry"/>
        </mxCell>
        <mxCell id="c5" value="&lt;b&gt;PK&lt;/b&gt; id (UUID)&lt;br&gt;email (unique)&lt;br&gt;phone (unique)&lt;br&gt;display_name&lt;br&gt;avatar_url&lt;br&gt;address&lt;br&gt;onboarded&lt;br&gt;role&lt;br&gt;createdAt" style="text;html=1;align=left;verticalAlign=top;spacingLeft=8;spacingTop=2;whiteSpace=wrap;fontSize=13;fillColor=#FFFFFF;fontFamily=Helvetica;fontColor=#111111;" vertex="1" parent="c4">
          <mxGeometry x="0" y="30" width="250" height="210" as="geometry"/>
        </mxCell>
        <mxCell id="c6" value="tax_profiles" style="swimlane;fontStyle=1;childLayout=stackLayout;horizontal=1;startSize=30;horizontalStack=0;resizeParent=1;resizeParentMax=0;resizeLast=0;collapsible=0;html=1;fillColor=#DAE8FC;strokeColor=#2B5797;strokeWidth=2;fontSize=15;fontFamily=Helvetica;fontColor=#111111;" vertex="1" parent="1">
          <mxGeometry x="40" y="60" width="240" height="328" as="geometry"/>
        </mxCell>
        <mxCell id="c7" value="&lt;b&gt;PK&lt;/b&gt; id&lt;br&gt;&lt;b&gt;FK&lt;/b&gt; user_id&lt;br&gt;monthly_income&lt;br&gt;annual_gross&lt;br&gt;rent_paid&lt;br&gt;pension_rate&lt;br&gt;computed_tax&lt;br&gt;net_income&lt;br&gt;is_exempt&lt;br&gt;cit_exemption&lt;br&gt;turnover, assets&lt;br&gt;flat_rate, rent_relief_rate&lt;br&gt;created_at" style="text;html=1;align=left;verticalAlign=top;spacingLeft=8;spacingTop=2;whiteSpace=wrap;fontSize=13;fillColor=#FFFFFF;fontFamily=Helvetica;fontColor=#111111;" vertex="1" parent="c6">
          <mxGeometry x="0" y="30" width="240" height="298" as="geometry"/>
        </mxCell>
        <mxCell id="c8" value="quiz_scores" style="swimlane;fontStyle=1;childLayout=stackLayout;horizontal=1;startSize=30;horizontalStack=0;resizeParent=1;resizeParentMax=0;resizeLast=0;collapsible=0;html=1;fillColor=#DAE8FC;strokeColor=#2B5797;strokeWidth=2;fontSize=15;fontFamily=Helvetica;fontColor=#111111;" vertex="1" parent="1">
          <mxGeometry x="40" y="410" width="240" height="152" as="geometry"/>
        </mxCell>
        <mxCell id="c9" value="&lt;b&gt;PK&lt;/b&gt; id&lt;br&gt;&lt;b&gt;FK&lt;/b&gt; user_id&lt;br&gt;score&lt;br&gt;total_questions&lt;br&gt;created_at" style="text;html=1;align=left;verticalAlign=top;spacingLeft=8;spacingTop=2;whiteSpace=wrap;fontSize=13;fillColor=#FFFFFF;fontFamily=Helvetica;fontColor=#111111;" vertex="1" parent="c8">
          <mxGeometry x="0" y="30" width="240" height="122" as="geometry"/>
        </mxCell>
        <mxCell id="c10" value="chat_sessions" style="swimlane;fontStyle=1;childLayout=stackLayout;horizontal=1;startSize=30;horizontalStack=0;resizeParent=1;resizeParentMax=0;resizeLast=0;collapsible=0;html=1;fillColor=#DAE8FC;strokeColor=#2B5797;strokeWidth=2;fontSize=15;fontFamily=Helvetica;fontColor=#111111;" vertex="1" parent="1">
          <mxGeometry x="540" y="330" width="240" height="152" as="geometry"/>
        </mxCell>
        <mxCell id="c11" value="&lt;b&gt;PK&lt;/b&gt; id&lt;br&gt;&lt;b&gt;FK&lt;/b&gt; user_id&lt;br&gt;title&lt;br&gt;created_at&lt;br&gt;updated_at" style="text;html=1;align=left;verticalAlign=top;spacingLeft=8;spacingTop=2;whiteSpace=wrap;fontSize=13;fillColor=#FFFFFF;fontFamily=Helvetica;fontColor=#111111;" vertex="1" parent="c10">
          <mxGeometry x="0" y="30" width="240" height="122" as="geometry"/>
        </mxCell>
        <mxCell id="c12" value="chat_messages" style="swimlane;fontStyle=1;childLayout=stackLayout;horizontal=1;startSize=30;horizontalStack=0;resizeParent=1;resizeParentMax=0;resizeLast=0;collapsible=0;html=1;fillColor=#DAE8FC;strokeColor=#2B5797;strokeWidth=2;fontSize=15;fontFamily=Helvetica;fontColor=#111111;" vertex="1" parent="1">
          <mxGeometry x="540" y="520" width="240" height="152" as="geometry"/>
        </mxCell>
        <mxCell id="c13" value="&lt;b&gt;PK&lt;/b&gt; id&lt;br&gt;&lt;b&gt;FK&lt;/b&gt; session_id&lt;br&gt;role&lt;br&gt;content&lt;br&gt;created_at" style="text;html=1;align=left;verticalAlign=top;spacingLeft=8;spacingTop=2;whiteSpace=wrap;fontSize=13;fillColor=#FFFFFF;fontFamily=Helvetica;fontColor=#111111;" vertex="1" parent="c12">
          <mxGeometry x="0" y="30" width="240" height="122" as="geometry"/>
        </mxCell>
        <mxCell id="c14" value="forum_topics" style="swimlane;fontStyle=1;childLayout=stackLayout;horizontal=1;startSize=30;horizontalStack=0;resizeParent=1;resizeParentMax=0;resizeLast=0;collapsible=0;html=1;fillColor=#DAE8FC;strokeColor=#2B5797;strokeWidth=2;fontSize=15;fontFamily=Helvetica;fontColor=#111111;" vertex="1" parent="1">
          <mxGeometry x="1040" y="60" width="240" height="196" as="geometry"/>
        </mxCell>
        <mxCell id="c15" value="&lt;b&gt;PK&lt;/b&gt; id&lt;br&gt;&lt;b&gt;FK&lt;/b&gt; user_id&lt;br&gt;title&lt;br&gt;content&lt;br&gt;tags (JSON)&lt;br&gt;upVotes, downVotes&lt;br&gt;created_at" style="text;html=1;align=left;verticalAlign=top;spacingLeft=8;spacingTop=2;whiteSpace=wrap;fontSize=13;fillColor=#FFFFFF;fontFamily=Helvetica;fontColor=#111111;" vertex="1" parent="c14">
          <mxGeometry x="0" y="30" width="240" height="166" as="geometry"/>
        </mxCell>
        <mxCell id="c16" value="forum_replies" style="swimlane;fontStyle=1;childLayout=stackLayout;horizontal=1;startSize=30;horizontalStack=0;resizeParent=1;resizeParentMax=0;resizeLast=0;collapsible=0;html=1;fillColor=#DAE8FC;strokeColor=#2B5797;strokeWidth=2;fontSize=15;fontFamily=Helvetica;fontColor=#111111;" vertex="1" parent="1">
          <mxGeometry x="1040" y="300" width="240" height="174" as="geometry"/>
        </mxCell>
        <mxCell id="c17" value="&lt;b&gt;PK&lt;/b&gt; id&lt;br&gt;&lt;b&gt;FK&lt;/b&gt; topic_id&lt;br&gt;&lt;b&gt;FK&lt;/b&gt; user_id&lt;br&gt;content&lt;br&gt;is_accepted&lt;br&gt;created_at" style="text;html=1;align=left;verticalAlign=top;spacingLeft=8;spacingTop=2;whiteSpace=wrap;fontSize=13;fillColor=#FFFFFF;fontFamily=Helvetica;fontColor=#111111;" vertex="1" parent="c16">
          <mxGeometry x="0" y="30" width="240" height="144" as="geometry"/>
        </mxCell>
        <mxCell id="c18" value="forum_votes" style="swimlane;fontStyle=1;childLayout=stackLayout;horizontal=1;startSize=30;horizontalStack=0;resizeParent=1;resizeParentMax=0;resizeLast=0;collapsible=0;html=1;fillColor=#DAE8FC;strokeColor=#2B5797;strokeWidth=2;fontSize=15;fontFamily=Helvetica;fontColor=#111111;" vertex="1" parent="1">
          <mxGeometry x="1040" y="510" width="240" height="152" as="geometry"/>
        </mxCell>
        <mxCell id="c19" value="&lt;b&gt;PK&lt;/b&gt; id&lt;br&gt;&lt;b&gt;FK&lt;/b&gt; topic_id&lt;br&gt;&lt;b&gt;FK&lt;/b&gt; user_id&lt;br&gt;direction (+1/−1)&lt;br&gt;UNIQUE(topic_id, user_id)" style="text;html=1;align=left;verticalAlign=top;spacingLeft=8;spacingTop=2;whiteSpace=wrap;fontSize=13;fillColor=#FFFFFF;fontFamily=Helvetica;fontColor=#111111;" vertex="1" parent="c18">
          <mxGeometry x="0" y="30" width="240" height="122" as="geometry"/>
        </mxCell>
        <mxCell id="c20" value="quiz_questions" style="swimlane;fontStyle=1;childLayout=stackLayout;horizontal=1;startSize=30;horizontalStack=0;resizeParent=1;resizeParentMax=0;resizeLast=0;collapsible=0;html=1;fillColor=#F5F5F5;strokeColor=#555555;strokeWidth=2;fontSize=15;fontFamily=Helvetica;fontColor=#111111;" vertex="1" parent="1">
          <mxGeometry x="40" y="600" width="240" height="152" as="geometry"/>
        </mxCell>
        <mxCell id="c21" value="&lt;b&gt;PK&lt;/b&gt; id&lt;br&gt;question&lt;br&gt;options (JSON)&lt;br&gt;correct_index&lt;br&gt;explanation" style="text;html=1;align=left;verticalAlign=top;spacingLeft=8;spacingTop=2;whiteSpace=wrap;fontSize=13;fillColor=#FFFFFF;fontFamily=Helvetica;fontColor=#111111;" vertex="1" parent="c20">
          <mxGeometry x="0" y="30" width="240" height="122" as="geometry"/>
        </mxCell>
        <mxCell id="c22" value="vat_items" style="swimlane;fontStyle=1;childLayout=stackLayout;horizontal=1;startSize=30;horizontalStack=0;resizeParent=1;resizeParentMax=0;resizeLast=0;collapsible=0;html=1;fillColor=#F5F5F5;strokeColor=#555555;strokeWidth=2;fontSize=15;fontFamily=Helvetica;fontColor=#111111;" vertex="1" parent="1">
          <mxGeometry x="300" y="720" width="220" height="152" as="geometry"/>
        </mxCell>
        <mxCell id="c23" value="&lt;b&gt;PK&lt;/b&gt; id&lt;br&gt;name (unique)&lt;br&gt;category&lt;br&gt;status&lt;br&gt;rate" style="text;html=1;align=left;verticalAlign=top;spacingLeft=8;spacingTop=2;whiteSpace=wrap;fontSize=13;fillColor=#FFFFFF;fontFamily=Helvetica;fontColor=#111111;" vertex="1" parent="c22">
          <mxGeometry x="0" y="30" width="220" height="122" as="geometry"/>
        </mxCell>
        <mxCell id="c24" value="tax_articles" style="swimlane;fontStyle=1;childLayout=stackLayout;horizontal=1;startSize=30;horizontalStack=0;resizeParent=1;resizeParentMax=0;resizeLast=0;collapsible=0;html=1;fillColor=#F5F5F5;strokeColor=#555555;strokeWidth=2;fontSize=15;fontFamily=Helvetica;fontColor=#111111;" vertex="1" parent="1">
          <mxGeometry x="820" y="720" width="220" height="174" as="geometry"/>
        </mxCell>
        <mxCell id="c25" value="&lt;b&gt;PK&lt;/b&gt; id&lt;br&gt;title, summary&lt;br&gt;content, source&lt;br&gt;category, url&lt;br&gt;is_featured&lt;br&gt;published_at" style="text;html=1;align=left;verticalAlign=top;spacingLeft=8;spacingTop=2;whiteSpace=wrap;fontSize=13;fillColor=#FFFFFF;fontFamily=Helvetica;fontColor=#111111;" vertex="1" parent="c24">
          <mxGeometry x="0" y="30" width="220" height="144" as="geometry"/>
        </mxCell>
        <mxCell id="c26" value="1 : N" style="edgeStyle=entityRelationEdgeStyle;html=1;strokeWidth=2;strokeColor=#333333;startArrow=ERmandOne;startFill=0;endArrow=ERmany;endFill=0;fontSize=12;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#111111;" edge="1" parent="1" source="c4" target="c6">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c27" value="1 : N" style="edgeStyle=entityRelationEdgeStyle;html=1;strokeWidth=2;strokeColor=#333333;startArrow=ERmandOne;startFill=0;endArrow=ERmany;endFill=0;fontSize=12;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#111111;" edge="1" parent="1" source="c4" target="c8">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c28" value="1 : N" style="edgeStyle=entityRelationEdgeStyle;html=1;strokeWidth=2;strokeColor=#333333;startArrow=ERmandOne;startFill=0;endArrow=ERmany;endFill=0;fontSize=12;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#111111;" edge="1" parent="1" source="c4" target="c14">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c29" value="1 : N" style="edgeStyle=entityRelationEdgeStyle;html=1;strokeWidth=2;strokeColor=#333333;startArrow=ERmandOne;startFill=0;endArrow=ERmany;endFill=0;fontSize=12;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#111111;" edge="1" parent="1" source="c4" target="c16">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c30" value="1 : N" style="edgeStyle=entityRelationEdgeStyle;html=1;strokeWidth=2;strokeColor=#333333;startArrow=ERmandOne;startFill=0;endArrow=ERmany;endFill=0;fontSize=12;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#111111;" edge="1" parent="1" source="c4" target="c18">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c31" value="1 : N" style="edgeStyle=entityRelationEdgeStyle;html=1;strokeWidth=2;strokeColor=#333333;startArrow=ERmandOne;startFill=0;endArrow=ERmany;endFill=0;fontSize=12;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#111111;edgeStyle=orthogonalEdgeStyle;exitX=0.5;exitY=1;exitDx=0;exitDy=0;entryX=0.5;entryY=0;entryDx=0;entryDy=0;" edge="1" parent="1" source="c4" target="c10">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c32" value="1 : N" style="edgeStyle=entityRelationEdgeStyle;html=1;strokeWidth=2;strokeColor=#333333;startArrow=ERmandOne;startFill=0;endArrow=ERmany;endFill=0;fontSize=12;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#111111;edgeStyle=orthogonalEdgeStyle;exitX=0.5;exitY=1;exitDx=0;exitDy=0;entryX=0.5;entryY=0;entryDx=0;entryDy=0;" edge="1" parent="1" source="c10" target="c12">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c33" value="1 : N" style="edgeStyle=entityRelationEdgeStyle;html=1;strokeWidth=2;strokeColor=#333333;startArrow=ERmandOne;startFill=0;endArrow=ERmany;endFill=0;fontSize=12;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#111111;edgeStyle=orthogonalEdgeStyle;exitX=0.5;exitY=1;exitDx=0;exitDy=0;entryX=0.5;entryY=0;entryDx=0;entryDy=0;" edge="1" parent="1" source="c14" target="c16">
          <mxGeometry relative="1" as="geometry"/>
        </mxCell>
        <mxCell id="c34" value="1 : N" style="edgeStyle=entityRelationEdgeStyle;html=1;strokeWidth=2;strokeColor=#333333;startArrow=ERmandOne;startFill=0;endArrow=ERmany;endFill=0;fontSize=12;labelBackgroundColor=#FFFFFF;fontFamily=Helvetica;fontColor=#111111;edgeStyle=orthogonalEdgeStyle;exitX=1;exitY=0.5;exitDx=0;exitDy=0;entryX=1;entryY=0.5;entryDx=0;entryDy=0;" edge="1" parent="1" source="c14" target="c18">
          <mxGeometry relative="1" as="geometry">
            <Array as="points">
              <mxPoint x="1320" y="150"/>
              <mxPoint x="1320" y="560"/>
            </Array>
          </mxGeometry>
        </mxCell>
        <mxCell id="c35" value="Grey tables are reference data with no user link. 1 : N = one-to-many (crow's foot marks the 'many' side)." style="text;html=1;align=left;verticalAlign=top;whiteSpace=wrap;fontSize=13;fontFamily=Helvetica;fontColor=#111111;" vertex="1" parent="1">
          <mxGeometry x="40" y="910" width="1000" height="30" as="geometry"/>
        </mxCell>
      </root>
    </mxGraphModel>
  </diagram>
</mxfile>
```
